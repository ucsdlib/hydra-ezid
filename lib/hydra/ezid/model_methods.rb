module Hydra
  module Ezid
    # TODO: move this to a nicer error file or something
    class Error < Exception
    end

    module ModelMethods
      extend ActiveSupport::Concern
      include do
        # include stuff
      end

      def mint_ezid
        raise Hydra::Ezid::Error.new("Cannot call #mint_ezid on unsaved object") unless self.persisted?
        @ezid = self.pid
      end
    end
  end
end
