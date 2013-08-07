module Hydra
  module Ezid
    extend ActiveSupport::Autoload
    autoload :Version
    autoload :Engine
    autoload :MintError
    autoload :ControllerBehavior
    autoload :ModelMethods

    def self.config(options = {}.with_indifferent_access)
      from_file = options.fetch(:from_file, default_file)
      except_keys = Array(options[:except_keys])
      from_file.to_hash.with_indifferent_access.delete_if { |k, v| except_keys.include? k.to_sym }
    end

    private
    def self.default_file
      YAML::load(ERB.new(IO.read(File.join(Rails.root, 'config', 'ezid.yml'))).result)
    end
  end
end
