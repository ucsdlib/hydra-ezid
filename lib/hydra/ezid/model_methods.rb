module Hydra
  module Ezid
    module ModelMethods
      extend ActiveSupport::Concern

      included do
        # TODO: include stuff such as AF callbacks and validations
      end

      def mint_ezid
        raise Hydra::Ezid::MintError.new("Cannot call #mint_ezid on unsaved object") unless self.persisted?

        conf = Hydra::Ezid.configurator
        session = ::Ezid::ApiSession.new(
          conf.doi.user,
          conf.doi.pass,
          conf.doi.scheme,
          conf.doi.naa
        )

        # TODO: When generate_ezid is ready, fix me
        #@ezid = session.generate_ezid(conf.doi.shoulder + self.pid)
        @ezid = conf.doi.scheme + conf.doi.naa + conf.doi.shoulder + self.pid
      end
    end

    def self.configurator
      CONSTANTINOPLE.ezid
    end
  end
end
