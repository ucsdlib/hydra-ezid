# Hydra::Ezid [![Version](https://badge.fury.io/rb/hydra-ezid.png)](http://badge.fury.io/rb/hydra-ezid) [![Build Status](https://travis-ci.org/psu-stewardship/hydra-ezid.png?branch=master)](https://travis-ci.org/psu-stewardship/hydra-ezid) [![Dependency Status](https://gemnasium.com/psu-stewardship/hydra-ezid.png)](https://gemnasium.com/psu-stewardship/hydra-ezid)

A Rails engine providing EZID services for Hydra applications

## Installation

Add this line to your application's Gemfile:

    gem 'hydra-ezid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hydra-ezid

## Usage

### Make your Models Ezid-able

Add `include Hydra::Ezid::ModelMethods` to the models for anything that you want to be able to mint EZIDs for.

Example:
```ruby
class GenericFile < ActiveFedora::Base
  include Hydra::Ezid::ModelMethods
  ezid_config do
    store_doi at: :descMetadata, in: :my_doi
    store_ark at: :properties, in: :some_ark
    find_creator at: :descMetadata, in: :author
    find_title at: :properties
    find_publisher at: :properties
    find_publication_year at: :descMetadata, in: :pubYear
end
```

## Developers

In order to make modifications to the gem code and run the tests, clone the repository then

```
    $ bundle install
    $ git submodule init
    $ git submodule update
    $ rake jetty:config
    $ rake jetty:start
    $ rake clean
    $ rake spec
```

## License

The hydra-ezid source code is freely available under the Apache 2.0 license.
[Read the copyright statement and license](/LICENSE.txt).

## Acknowledgements

This software has been developed by and is brought to you by the Hydra community.  Learn more at the [Project Hydra website](http://projecthydra.org)

![Project Hydra Logo](https://github.com/uvalib/libra-oa/blob/a6564a9e5c13b7873dc883367f5e307bf715d6cf/public/images/powered_by_hydra.png?raw=true)
