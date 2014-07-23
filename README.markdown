# Mapserver
[![Build Status](https://travis-ci.org/NERC-CEH/puppet-mapserver.svg?branch=master)](https://travis-ci.org/NERC-CEH/puppet-mapserver)
## Overview

This is the mapserver module. It installs the mapserver and creates an apache vhost to run the mapserver cgi application

## Module Description

[MapServer](mapserver.org) is an open source web mapping application. It can be used to publish WMS' from various spatial data formats

This module will install the mapserver cgi application and set up an apache vhost to call mapserver from. MapServer is available from the ubuntu main repository and the [ubuntu gis ppa](launchpad.net/~ubuntugis) therefore this module will manage the apt::source for ubuntugis if required. By default, the ubuntugis ppa is not set up. See usage on how to enable this

You can choose between installing the mapserver application from the stable or testing repository. If neither of this are suitable you are free to specify your own source.

This module will also install and manage the gdal suite of tools.

## Setup

### What MapServer affects

* Adds a Apt Source for installing mapserver from ubuntugis' ppa
* Installs the mapserver and gdal packages
* Sets up an apache vhost which runs the cgi application using fcgid

## Usage

Install MapServer and gdal and create an apache vhost on port 9000

    include mapserver

Install mapserver from the ubuntugis-unstable ppa on port 5000

    class { 'mapserver' :
      manage_sources => true,
      source         => 'unstable',
      port           => 5000,
    }

## Dependencies

This module requires puppetlabs/apache and puppetlabs/apt for managing the ppa and apache vhost

## Limitations

This module has been tested on ubuntu (12.04, 14.04) lts

## Contributors

Christopher Johnson - cjohn@ceh.ac.uk
