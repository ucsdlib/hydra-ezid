module Hydra
  module Ezid
    extend ActiveSupport::Autoload
    autoload :Version
    autoload :ControllerBehavior
    autoload :ModelMethods
    class Engine < ::Rails::Engine
      engine_name 'ezid'
    end
  end
end
