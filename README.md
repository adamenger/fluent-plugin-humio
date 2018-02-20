# Fluent::Plugin::[Humio](https://humio.com), a plugin for [Fluentd](http://fluentd.org)


Send your logs to [Humio](https://humio.com). You'll need an enterprise install of Humio or a free account over at [cloud.humio.com](https://cloud.humio.com)

Current maintainers: @adamenger

* [Installation](#installation)
* [Contact](#contact)
* [Contributing](#contributing)
* [Running tests](#running-tests)

## Requirements

NOTE: This plugin is built for FluentD 1.x 

## Installation

Since I haven't published this to rubygems.org yet, you'll have to download and build this gem manually.

First clone the repo:

```
$ git clone git@github.com/adamenger/fluent-plugin-humio.git
```

Then build the gem:

```
$ gem build fluent-plugin-humio.gemspec
```

Finally install the gem locally

```
$ gem install --local fluent-plugin-humio-0.0.1.gem
```

If it installed properly, you should be able to see it when you run `gem list`:

```
$ gem list | grep humio
fluent-plugin-humio (0.0.1)
```

## Usage

In your Fluentd configuration, use `@type humio`. 

Here's an example of what your config might look like if you were shipping your logs to a local humio instance over `http`. 

```
<match my.logs>
  @type humio
  host localhost
  port 8080
  dataspace_name fluentd
  ingest_token asdf1234
  scheme https
</match>
```

Shipping your logs to the humio cloud service:

```
<match my.logs>
  @type humio
  host cloud.humio.com
  port 443
  dataspace_name your-dataspace-name
  ingest_token asdf1234
  scheme https
</match>
```

You can add optional `<buffer>` options to the config if you'd like to flush faster or slower based on your preference and testing:

```
<match my.logs.**>
  @type humio
  host cloud.humio.com
  port 443
  scheme https
  ingest_token your-token-here
  dataspace_name your-dataspace-name-here
  <buffer tag,time>
    timekey 1s
    timekey_wait 10s
    flush_interval 5
  </buffer>
</match>
```

## Configuration

### host

```
host cloud.humio.com
```

### ingest_token, dataspace, path, scheme

```
ingest_token asdf1234
dataspace your_dataspace_name
path /custom_path/
scheme https
```

## Contact

If you have a question, [open an Issue](https://github.com/adamenger/fluent-plugin-humio/issues) or jump into the Meet Humio slack. 

## Contributing

Pull Requests are welcomed.
