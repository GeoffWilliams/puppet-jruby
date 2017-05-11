[![Build Status](https://travis-ci.org/GeoffWilliams/puppet-jruby.svg?branch=master)](https://travis-ci.org/GeoffWilliams/puppet-jruby)
# jruby

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with jruby](#setup)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

Download and extract JRuby to the directory of your choice.  Uses [puppet-archive](https://forge.puppet.com/puppet/archive) to do the download and
creates some handy binaries under `/usr/local/bin`

## Setup

Requires Internet access to perform download _or_ JRuby tarballs must be hosted
on an internal, accessible server.  Files can be downloaded using anything
supported by the [puppet-archive](https://forge.puppet.com/puppet/archive#archive)
module.

If hosting files locally, tarballs must obey the naming convention:

```
jruby-bin-VERSION.tar.gz
```

Where `VERSION` is the version number of the release.  For example, version
`9.1.8.0` *must* be hosted in the file `jruby-bin-9.1.8.0.tar.gz`


## Usage
See reference and examples

## Reference
[generated documentation](https://rawgit.com/GeoffWilliams/puppet-jruby/master/doc/index.html).

Reference documentation is generated directly from source code using [puppet-strings](https://github.com/puppetlabs/puppet-strings).  You may regenerate the documentation by running:

```shell
bundle exec puppet strings
```

## Limitations

* Linux only
* Not supported by Puppet, Inc.

## Development

PRs accepted :)

## Testing
This module supports testing using [PDQTest](https://github.com/declarativesystems/pdqtest).


Test can be executed with:

```
bundle install
make
```

See `.travis.yml` for a working CI example

## Acknowledgement
Based on the [jlbfalcao/jruby](https://forge.puppet.com/jlbfalcao) forge module
