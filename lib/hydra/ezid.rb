require 'active_support'
require 'active-fedora'
require 'yaml'
require 'ezid'
module Hydra
  module Ezid
    extend ActiveSupport::Autoload
    autoload :Version
    autoload :Exceptions
    autoload :Identifiable

    class << self
      def config(*cfg_object)
        cfg_object = cfg_object.length > 1 ? cfg_object : cfg_object.first
        case cfg_object
        when File
          file_to_hash(cfg_object)
        when Hash
          default_file.slice(*cfg_object.keys).deep_merge(cfg_object)
        when Array, Symbol, String
          default_file.slice(*cfg_object)
        else
          default_file
        end
      rescue StandardError => err
        raise ConfigError.new("Not a valid config object: #{cfg_object} (#{err})")
      end

      private
      def file_to_hash(file)
        YAML::load(file).with_indifferent_access
      end

      def default_file
        file_to_hash(File.open(File.join('config', 'ezid.yml')))
      end
    end
  end
end
