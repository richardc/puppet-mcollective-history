# mcollective

#### Table of Contents

1. [Overview](#overview)
2. [Module Description - What the module does and why it is useful](#module-description)
3. [Setup - The basics of getting started with ntp](#setup)
    * [What mcollective affects](#what-ntp-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mcollective](#beginning-with-ntp)
4. [Usage - Configuration options and additional functionality](#usage)
5. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
5. [Limitations - OS compatibility, etc.](#limitations)
6. [Development - Guide for contributing to the module](#development)

## Overview

The mcollective module installs, configures, and manages the mcollective
agents, clients, and middleware.

## Module Description

The mcollective module handles installing and configuring mcollective across a
range of operating systems and distributions.  Where possible we follow the
standards laid down by the
[MCollective Standard Deployment guide](http://docs.puppetlabs.com/mcollective/deploy/standard.html).

## MCollective Terminology

A quick aside, mcollective's terminology differs a little from what you might
be used to in puppet.  There are 3 main components, the client (the mco
commands you run to control your servers), the server (a deamon that runs on
all of your managed nodes and executes the commands), and the middleware (a
message broker which the servers and agent will connect to).

If it helps to these to puppet concepts you loosely have:

* Puppet Master - Middleware
* Puppet Agent  - MCollective Server
*               - MCollective Client


## Setup

### What mcollective affects

On a server

* mcollective package.
* mcollective server configuration file
* mcollective service

On a client

* mcollective-client package.
* mcollective client configuration file.
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
  middleware_hosts => [ 'broker1.corp.com', 'broker2.corp.com' ],
}
```

## Usage

Your primary interactions with the mcollective module will be though the main
mcollective class, and the defined types `mcollective::user`,
`mcollective::plugin`, `mcollective::agent`,
`mcollective::agent::actionpolicy`.

### I just want to run it, what's the minimum I need?

```puppet
node 'middleware.example.com' {
  class { '::mcollective':
    middleware       => true,
    middleware_hosts => [ 'middleware.example.com' ],
  }
}

node 'server1.example.com' {
  class { '::mcollective':
    middleware_hosts => [ 'middleware.example.com' ],
  }
}

node 'control.example.com' {
  class { '::mcollective':
    client            => true,
    middleware_hosts => [ 'middleware.example.com' ],
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
node 'middleware.example.com' {
  class { '::mcollective':
    middleware         => true,
    middleware_hosts   => [ 'middleware.example.com' ],
    middleware_ssl     => true,
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/server.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/server.pem',
  }
}

node 'server1.example.com' {
  class { '::mcollective':
    middleware_hosts => [ 'middleware.example.com' ],
    middleware_ssl   => true,
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/server.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/server.pem',
  }
}

node 'control.example.com' {
  class { '::mcollective':
    client             => true,
    middleware_hosts   => [ 'middleware.example.com' ],
    middleware_ssl     => true,
    ssl_ca_cert        => 'puppet:///modules/site_mcollective/certs/ca.pem',
    ssl_server_public  => 'puppet:///modules/site_mcollective/certs/server.pem',
    ssl_server_private => 'puppet:///modules/site_mcollective/private_keys/server.pem',

  }
}
```


### `class { '::mcollective': }` Parameters

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

##### `middleware_ssl`

Boolean: defaults to false.  Whether to talk to the middleware over a ssl
protected channel.  Highly recommended.  Requires `mcollective::ssl_ca_cert`,
`mcollective::ssl_server_public`, `mcollective::ssl_server_private` parameters
for the server/client install.


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

