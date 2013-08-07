module Hydra
  module Ezid
    module ModelMethods
      extend ActiveSupport::Concern

      included do
        # TODO: include stuff such as AF callbacks and validations
      end

      def mint_ezid
        raise Hydra::Ezid::MintError.new("Cannot call #mint_ezid on unsaved object") unless self.persisted?
        @ezid = self.pid
      end
    end

    def self.configurator
      CONSTANTINOPLE.ezid
    end
  end
end
