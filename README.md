#### Table of Contents

1. [Overview](#overview)
1. [Module Description - What the module does and why it is useful](#module-description)
1. [Usage - Configuration options and additional functionality](#usage)
 1. [Installing jmxtrans](#installing-jmxtrans)
 1. [Managing the service](#managing-the-service)
 1. [Configuring servers and queries](#configuring-servers-and-queries)
1. [Development - Guide for contributing to the module](#development)

## Overview

Configure jmxtrans for collecting and exporting JVM metrics data.

This module was adopted from [PLoperations](https://github.com/ploperations) and was available as
`ploperations/jmxtrans` before.

## Module Description

This module can be used to install and manage the jmxtrans service, as well as
configure how it connects to JVM processes, what data it pulls out, and where
it sends the data it collects.

For more information on jmxtrans, see [the source repo][jmxtrans-source].

### Installing jmxtrans

If you have a repository configured on the system with a `jmxtrans` package
available, you can install jmxtrans by setting the `package_name` parameter on
the main `jmxtrans` class.

~~~puppet
class { '::jmxtrans':
  package_name => 'jmxtrans',
}
~~~

If you have a package available on the local filesystem or remotely over HTTP
(if your package manager supports it), you can set the `package_source`
parameter. Note that if you are on anything other than a Debian or EL-based
operating system, you will also need to set `package_provider`.

~~~puppet
class { '::jmxtrans':
  package_name   => 'jmxtrans',
  package_source => 'http://central.maven.org/maven2/org/jmxtrans/jmxtrans/254/jmxtrans-254.rpm',
}
~~~

### Managing the service

If you want to manage the service, you can set the `service_name` parameter,
which will set `ensure => running` on the service.

~~~puppet
class { '::jmxtrans':
  package_name => 'jmxtrans',
  service_name => 'jmxtrans',
}
~~~

### Configuring servers and queries

The `jmxtrans::query` defined type is used to configure "servers" and "queries"
as described in [the jmxtrans documentation][jmxtrans-docs].

Example usage:

~~~puppet
jmxtrans::query { 'puppetserver':
  host     => 'localhost',
  port     => 1099,
  queries  => [
    {
      object       => "metrics:name=puppetlabs.${facts['hostname']}.compiler.compile",
      attributes   => ['Max', 'Min', 'Mean', 'StdDev', 'Count'],
      result_alias => 'puppetlabs.puppetmaster.compiler.compile',
      writers      => [
        {
          '@class'          => 'com.googlecode.jmxtrans.model.output.KeyOutWriter',
          outputFile        => '/tmp/puppetserver-compile-metrics.txt',
          maxLogFileSize    => '10MB',
          maxLogBackupFiles => '200',
          debug             => true,
        },
      ],
    },
    {
      object       => "metrics:name=puppetlabs.${facts['hostname']}.jruby.num-free-jrubies",
      attributes   => ['Value'],
      result_alias => 'puppetlabs.puppetmaster.jruby.num-free-jrubies',
      writers      => [
        {
          '@class'          => 'com.googlecode.jmxtrans.model.output.KeyOutWriter',
          outputFile        => '/tmp/puppetserver-jruby-metrics.txt',
          maxLogFileSize    => '10MB',
          maxLogBackupFiles => '200',
          debug             => true,
        },
      ],
    },
  ],
}
~~~

This will configure jmxtrans to connect to a JMX RMI on `localhost` listening
on port 1099, and it will:

 - extract the values for `Max`, `Min`, `Mean`, `StdDev`, and `Count` from the
   `metrics:name=puppetlabs.${facts['hostname']}.compiler.compile` object and
   write them to `/tmp/puppetserver-compile-metrics.txt`.
 - extract the value of the `Value` attribute for the object
   `metrics:name=puppetlabs.${facts['hostname']}.jruby.num-free-jrubies` and
   write it to `/tmp/puppetserver-jruby-metrics.txt`.
   
If you intend to use the GraphiteWriter, StdoutWriter or GelfWriter on all the objects for
the server, there are top level parameters that you can set which will be
inherited by all the query objects.

## Development

Pull Requests on GitHub are welcome. Please include tests for any new features
or functionality change. See [rspec-puppet] for details on writing unit tests
for Puppet.

Always keep the reference up to date by running

    bundle exec puppet strings generate --format markdown


[jmxtrans-source]: https://github.com/jmxtrans/jmxtrans
[jmxtrans-docs]: https://github.com/jmxtrans/jmxtrans/wiki/Queries
[rspec-puppet]: http://rspec-puppet.com/
