module Hydra
  module Ezid
    module ModelMethods
      extend ActiveSupport::Concern
      include do
        # include stuff
      end

      def mint_ezid
        raise "Cannot call #mint_ezid on unsaved object" unless self.persisted?
      end
    end
  end
end
