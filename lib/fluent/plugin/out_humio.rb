# encoding: UTF-8
require 'date'
require 'httparty'
require 'time'
require 'json'
require 'uri'
require 'fluent/plugin/output'

module Fluent::Plugin
  class HumioOutput < Output
    Fluent::Plugin.register_output('humio', self)
    DEFAULT_BUFFER_TYPE = "memory"
    class AuthenticationFailure < StandardError; end
    class GenericFailure < StandardError; end

    config_param :host, :string,  :default => 'localhost'
    config_param :port, :integer, :default => 8080
    config_param :ingest_token, :string, :default => nil
    config_param :dataspace_name, :string, :default => nil
    config_param :scheme, :string, :default => 'https'
    config_param :tags, :hash, default: {}, symbolize_keys: true, value_type: :string

    helpers :thread

    config_section :buffer do
      config_set_default :@type, DEFAULT_BUFFER_TYPE
    end

    def configure(conf)
      super
      # You can also refer raw parameter via conf[name].
      # @path = conf['path']
      @host           = conf['host']
      @port           = conf['port']
      @path           = conf['path']
      @ingest_token   = conf['ingest_token']
      @dataspace_name = conf['dataspace_name']
      @scheme         = conf['scheme']
    end

    # This method is called when starting.
    # Open sockets or files here.
    def start
      super
    end

    # This method is called when shutting down.
    # Shutdown the thread and close sockets or files here.
    def shutdown
      super
    end

    # This method is called when an event reaches to Fluentd.
    # Convert the event to a raw string.
    def write(chunk)
      data = chunk.read

      # assemble the url we're going to ship our events to
      url = "#{@scheme}://#{@host}:#{@port}/api/v1/dataspaces/#{@dataspace_name}/ingest"

      # log the url we're connecting to after it's been interpolated from the config
      log.debug "Humio url: #{url}"

      # our events array
      events = [] 
      
      # set up our auth + app headers
      headers = {
        "Authorization" => "Bearer #{@ingest_token}",
        "Content-Type" => "application/json"
      }

      # log our outbound request headers
      log.debug "Humio Outbound Headers: #{headers}"
      
      # loop through each event in the current chunk
      chunk.each do |time, record|
        # assemble message
        message = {"timestamp" => Time.at(time.to_i).iso8601, "attributes" => record}

        # push to bulk events array
        events.push(message)
      end
      
      # create the request body we're going to ship 
      bulk_events = Array.new(1, {'tags' => @tags, 'events' => events })

      # debug log the events
      log.debug bulk_events

      # send the event!
      response = HTTParty.post(url, :headers => headers, :body => bulk_events.to_json)

      # if we fail to send the request, raise an error so that we can properly queue the chunk for a retry
      case response.code
      when 200
        log.debug response.code
        log.debug "HUMIO SUCCESS #{response.inspect}"
      when 401
        log.debug response.code
        log.debug "HUMIO AUTH FAILURE #{response.inspect}"
        raise AuthenticationFailure, "Authentication failure connecting to Humio!" 
      else
        log.debug response.code
        log.debug "HUMIO FAILURE #{response.inspect}"
        raise GenericFailure, "Authentication failure connecting to Humio!" 
      end
   end
  end
end
