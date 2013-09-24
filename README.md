# mcollective

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with mcollective](#setup)
    * [What the mcollective module affects](#what-the-mcollective-module-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mcollective](#beginning-with-mcollective)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The mcollective module installs, configures, and manages the mcollective
agents, clients, and middleware of an mcollective cluster.

## Module Description

The mcollective module handles installing and configuring mcollective across a
range of operating systems and distributions.  Where possible we follow the
standards laid down by the
[MCollective Standard Deployment guide](http://docs.puppetlabs.com/mcollective/deploy/standard.html).

### MCollective Terminology

A quick aside, mcollective's terminology differs a little from what you might
be used to in puppet.  There are 3 main components, the client (the mco
commands you run to control your servers), the server (a deamon that runs on
all of your managed nodes and executes the commands), and the middleware (a
message broker which the servers and agent will connect to).

If it helps to these to puppet concepts you loosely have:

* Middleware -> Puppet Master
* MCollective Server -> Puppet Agent
* MCollective Client -> no direct equivalent


## Setup

### What the mcollective module affects

On a server

* mcollective package
* mcollective server configuration file
* mcollective service

On a client

* mcollective-client package
* mcollective client configuration file
* optionally user configuration files (~/.mcollective and ~/.mcollective.d)

On a middleware host

* broker installation
* broker configuration

### Beginning with mcollective

Your main entrypoint to the mcollective module is the mcollective class, so
assuming you have your middleware configured on a node this is all you need to
add a server to mcollective.

```puppet
class { '::mcollective':
  middleware_hosts => [ 'broker1.example.com' ],
}
```

## Usage

Your primary interaction with the mcollective module will be though the main
mcollective class, with secondary configuration managed by the defined types
`mcollective::user`, `mcollective::plugin`, `mcollective::agent`, and
`mcollective::agent::actionpolicy`.

### I just want to run it, what's the minimum I need?

```puppet
node 'broker1.example.com' {
  class { '::mcollective':
    middleware       => true,
    middleware_hosts => [ 'broker1.example.com' ],
  }
}

node 'server1.example.com' {
  class { '::mcollective':
    middleware_hosts => [ 'broker1.example.com' ],
  }
}

node 'control1.example.com' {
  class { '::mcollective':
    client            => true,
    middleware_hosts => [ 'broker1.example.com' ],
  }
}
```

This default install will be using *no* TLS, a set of well-known usernames and
passwords, and the psk securityprovider.  This is against the recommendataion
of the standard deploy guide but does save you from having to deal with ssl
certificates to begin with.


### I'd like to secure the transport channel, how do I do that?

Create some certificates and put them in a site_mcollective module.

XXX flesh this out way more


```puppet
node 'broker1.example.com' {
  class { '::mcollective':
    middleware         => true,
    middleware_hosts   => [ 'broker1.example.com' ],
    middleware_ssl     => true,
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/server.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/server.pem',
  }
}

node 'server1.example.com' {
  class { '::mcollective':
    middleware_hosts => [ 'broker1.example.com' ],
    middleware_ssl   => true,
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/server.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/server.pem',
  }
}

node 'control.example.com' {
  class { '::mcollective':
    client             => true,
    middleware_hosts   => [ 'broker1.example.com' ],
    middleware_ssl     => true,
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/server.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/server.pem',
  }
}
```

### The `::mcollective::` class

The `mcollective` class is the main entry point to the module.  From here you
can configure the behaviour of your mcollective install of server, client, and
middleware.

#### Parameters

The following parameters are available to the mcollective class:

##### `server`

Boolean: defaults to true.  Whether to install the mcollective server on this
node.

##### `client`

Boolean: defaults to false.  Whether to install the mcollective client
application on this node.

##### `middleware`

Boolean: defaults to false.  Whether to install middleware that matches
`$mcollective::connector` on this node.

Currently supported are `activemq`, `rabbitmq`, and `redis`

##### `activemq_template`

String: defaults to 'mcollective/activemq.xml.erb'.  Template to use when
configuring activemq middleware.

##### `activemq_console`

Boolean: defaults to false.  Whether to enable the jetty admin console when
configuring the activemq middleware.

##### `activemq_config`

String: defaults to undef.  If supplied the contents of the activemq.xml
configuration file to use when configuring activemq middleware.  Bypasses
`mcollective::activemq_template`

##### `activemq_confdir`

String: default based on distribution.  The directory to copy ssl certificates
to when configuring activemq middleware with `mcollective::middleware_ssl`.

##### `rabbitmq_confdir`

String: defaults to '/etc/rabbitmq'. The directory to copy ssl certificates to
when configuring rabbitmq middleware with `mcollective::middleware_ssl`.

##### `rabbitmq_vhost`

String: defaults to '/mcollective'.  The vhost to connect to/manage when using
rabbitmq middleware.

##### `manage_packages`

Boolean: defaults to true.  Whether to install mcollective and mcollective-
client packages when installing the server and client components.

##### `version`

String: defaults to 'present'.  What version of packages to `ensure` when
`mcollective::manage_packages` is true.

##### `main_collective`

String: defaults to 'mcollective'.  The name of the main collective for this
client/server.

##### `collectives`

String: defaults to 'mcollective'.  Comma seperated list of collectives this
server should join.

##### `connector`

String: defaults to 'activemq'.  Name of the connector plugin to use.

##### `securityprovider`

String: defaults to 'psk'.  Name of the security provider plugin to use.
'ssl' is recommended but requires some additional setup.

##### `psk`

String: defaults to 'changemeplease'.  Used by the 'psk' security provider as
the pre-shared key to secure the collective with.

##### `factsource`

String: defaults to 'yaml'.  Name of the factsource plugin to use on the
server.

##### `yaml_fact_path`

String: defaults to '/etc/mcollective/facts.yaml'.  Name of the file the
'yaml' factsource plugin should load facts from.

##### `classesfile`

String: defaults to '/var/lib/puppet/state/classes.txt'.  Name of the file the
server will load the configuration management class for filtering.

##### `rpcauthprovider`

String: defaults to 'action_policy'.  Name of the RPC Auth Provider to use on
the server.

##### `rpcauditprovider`

String: defaults to 'logfile'.  Name of the RPC Audit Provider to use on the
server.

##### `registration`

String: defaults to undef.  Name of the registration plugin to use on the
server.

##### `core_libdir`

String: default is based on platform.  Path to the core plugins that are
installed by the mcollective-common package.

##### `site_libdir`

String: default is based on platform.  Path to the site-specific plugins that
the `mcollective::plugin` type will install with its `source` parameter.

This path will be managed and purged by puppet, so don't point it at
core_libdir or any other non-dedicated path.

##### `server_config_file`

String: default is '/etc/mcollective/server.cfg'.  Path to the server
configuration file.

##### `server_logfile`

String: defaults to '/var/log/mcollective.log'.  Logfile the mcollective
server should log to.

##### `server_loglevel`

String: defaults to 'info'.  Level the mcollective server should log at.

##### `server_daemonize`

String: defaults to '1'.  Should the mcollective server daemonize when
started.

##### `client_config_file`

String: defaults to '/etc/mcollective/client.cfg'.  Path to the client
configuration file.

##### `client_logger_type`

String: defaults to 'console'.  What type of logger the client should use.

##### `client_loglevel`

String: defaults to 'warn'.  Level the mcollective client should log at.

##### `middleware_hosts`

Array of strings: defaults to [].  Where the middleware servers this
client/server should talk to are.

##### `middleware_user`

String: defaults to 'mcollective'. Username to use when connecting to the
middleware.

##### `middleware_password`

String: defaults to 'marionette'.  Password to use when connecting to the
middleware.

##### `middleware_port`

String: defaults to '61613'.  Port number to use when connecting to the
middleware over an unencrypted connection.

##### `middleware_ssl_port`

String: defaults to '61614'. Port number to use when connecting to the
middleware over a ssl connection.

##### `middleware_ssl`

Boolean: defaults to false.  Whether to talk to the middleware over a ssl
protected channel.  Highly recommended.  Requires `mcollective::ssl_ca_cert`,
`mcollective::ssl_server_public`, `mcollective::ssl_server_private` parameters
for the server/client install.

##### `ssl_ca_cert`

String: defaults to undef.  A file source that points to the ca certificate
used to manage the ssl keys of the mcollective install.

##### `ssl_server_public`

String: defaults to undef.  A file source that points to the public key or
certificate of the server keypair.

##### `ssl_server_private`

String: defaults to undef.  A file source that points to the private key of
the server keypair.

##### `ssl_client_certs`

String: defaults to 'puppet:///modules/mcollective/empty'.  A file source that
contains a directory of user certificates which are used by the ssl security
provider in authenticating user requests.

### `mcollective::user` defined type

`mcollective::user` installs a client configuration and any needed client
certificates in a users home directory.

#### Parameters

##### `username`

String: defaults to $name. The username of the user to install for.

##### `homedir`

String: defaults to "/home/${name}".  The home directory of the user to
install for.

##### `certificate`

String: defaults to undef.  A file source for the certificate of the user.
Used by the 'ssl' securityprovider to set the identity of the user.

##### `private_key`

String: defaults to undef.  A file source for the private key of the user.
Used when `mcollective::middleware_ssl` is true to connect to the middleware
and by the 'ssl' securityprovider to sign messages as from this user.

### `mcollective::plugin` defined type

`mcollective::plugin` installs a plugin from a source uri or a package.

#### Parameters

### `mcollective::agent` defined type

`mcollective::agent` configures an agent for use with actionpolicy in
conjunction with `mcollective::agent::actionpolicy`.

#### Parameters

### `mcollective::agent::actionpolicy` defined type

`mcollective::agent::actionpolicy` represents a single actionpolicy policy
entry.

#### Parameters

### `mcollective::common::setting` defined type

`mcollective::common::setting` declares a setting that is common between
server and client.

### `mcollective::server::setting` defined type

`mcollective::server::setting` declares a setting that is exclusive to a server.

### `mcollective::client::setting` defined type

`mcollective::client::setting` declares a setting that is common to clients
and users.

### `mcollective::user::setting` defined type

`mcollective::user::setting` declares a setting that is specific to a user.

## Reference


## Limitations

This module has been built on and tested against Puppet 3.0 and higher.

The module has been tested on:

* CentOS 6
* Ubuntu 12.04

Testing on other platforms has been light and cannot be guaranteed.

## Development

Puppet Labs modules on the Puppet Forge are open projects, and community
contributions are essential for keeping them great. We can’t access the
huge number of platforms and myriad of hardware, software, and deployment
configurations that Puppet is intended to serve.

We want to keep it as easy as possible to contribute changes so that our
modules work in your environment. There are a few guidelines that we need
contributors to follow so that we can have a chance of keeping on top of things.

You can read the complete module contribution guide [on the Puppet Labs wiki.](http://projects.puppetlabs.com/projects/module-site/wiki/Module_contributing)

Current build status is: [![Build Status](https://travis-ci.org/richardc/puppet-mcollective.png)](https://travis-ci.org/richardc/puppet-mcollective)

