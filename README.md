# Hydra::Ezid [![Version](https://badge.fury.io/rb/hydra-ezid.png)](http://badge.fury.io/rb/hydra-ezid) [![Build Status](https://travis-ci.org/psu-stewardship/hydra-ezid.png?branch=master)](https://travis-ci.org/psu-stewardship/hydra-ezid) [![Dependency Status](https://gemnasium.com/psu-stewardship/hydra-ezid.png)](https://gemnasium.com/psu-stewardship/hydra-ezid)

A Ruby gem providing EZID services for Hydra applications

## Installation

Add this line to your application's Gemfile:

    gem 'hydra-ezid'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hydra-ezid

## Usage

### Make your Models Identifiable by EZID

First, add a config file to your app in `config/ezid.yml` that looks like the following:

```yaml
doi:
  user: "foo"
  pass: "bar"
  scheme: "doi"
  shoulder: "sldr1"
  naa: "10.1000"

ark:
  user: "foo"
  pass: "quux"
  scheme: "ark"
  shoulder: "sldr2"
  naa: "98765"
```

Add `include Hydra::Ezid::Identifiable` to the models you want EZIDs for.

Example:
```ruby
class GenericFile < ActiveFedora::Base
  include Hydra::Ezid::Identifiable
  has_metadata :name => 'properties', :type => ActiveFedora::SimpleDatastream { |m| m.field 'some_ark',  :string }
  has_metadata :name => 'descMetadata', :type => ActiveFedora::SimpleDatastream { |m| m.field 'my_doi',  :string }
  delegate_to :properties, [:some_ark], unique: true
  delegate_to :descMetadata, [:doi], unique: true
  ezid_config do
    store_doi at: :descMetadata, in: :my_doi
    store_ark at: :properties, in: :some_ark
    find_creator at: :descMetadata, in: :author
    find_title at: :properties
    find_publisher at: :properties
    find_publication_year at: :descMetadata, in: :pubYear
end
```

And then you can mint EZIDs on your model instances:

```ruby
gf = GenericFile.find('id:123')
gf.mint_ezid # will mint both a DOI and an ARK as configured in the default YAML file
gf.mint_ark # mint only an ARK (as configured in default YAML)
gf.mint_doi # mint only a DOI (as configured in default YAML)
# Override default configuration
## Pass in a symbol or string corresponding to a key in your YAML
gf.mint_ezid(Hydra::Ezid.config(:ark)) # will mint only an ARK
gf.mint_ezid(Hydra::Ezid.config('ark')) # will mint only an ARK
gf.mint_ezid(Hydra::Ezid.config(:doi)) # will mint only a DOI
gf.mint_ezid(Hydra::Ezid.config('doi')) # will mint only a DOI
## Pass in an array (or multiple args)
gf.mint_ezid(Hydra::Ezid.config([:ark, 'doi'])) # will mint an ARK and a DOI (useful if your YAML has > 2 entries)
gf.mint_ezid(Hydra::Ezid.config(:ark, 'doi')) # or eliminate the brackets
## Pass in a hash
gf.mint_ezid(Hydra::Ezid.config({doi: {shoulder: 'sldr4', naa: '20.2000'}})) # will use default YAML config, minting only a DOI with overridden shoulder and NAA values
## Pass in a file object for an alternative YAML config
gf.mint_ezid(Hydra::Ezid.config(File.open('config/whatever.yml'))
gf.save # make sure to persist changes to your object
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
