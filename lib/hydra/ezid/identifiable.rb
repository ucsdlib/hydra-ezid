module Hydra
  module Ezid
    module Identifiable
      extend ActiveSupport::Concern

      included do
        def self.ezid_registry
          @@ezid_registry ||= {}
        end
        def self.ezid_config(&block)
          block.call
        end
        def self.store_doi(options)
          ezid_register(options, :doi)
        end
        def self.store_ark(options)
          ezid_register(options, :ark)
        end
        def self.find_creator(options)
          # TODO: unstub
        end
        def self.find_title(options)
          # TODO: unstub
        end
        def self.find_publisher(options)
          # TODO: unstub
        end
        def self.find_publication_year(options)
          # TODO: unstub
        end

        # TODO: include stuff such as AF callbacks and validations

        private
        def self.ezid_register(options, scheme)
          datastream = options[:at]
          field = options.fetch(:in, scheme)
          ezid_registry[scheme] = { datastream: datastream, field: field }
        end
      end

      def mint_ezid(conf = Hydra::Ezid.config)
        raise Hydra::Ezid::MintError.new("Cannot mint EZID until object is saved") unless self.persisted?
        self.class.ezid_registry.each_pair do |scheme, opts|
          scheme_conf = conf.values.find { |subkeys| subkeys['scheme'] == scheme.to_s }
          next unless scheme_conf
          session = ::Ezid::ApiSession.new(scheme_conf['user'],
                                    scheme_conf['pass'],
                                    scheme_conf['scheme'].to_sym,
                                    scheme_conf['naa'])
          record = session.mint
          id = record.identifier
          datastreams["#{opts[:datastream]}"].send("#{opts[:field]}=", id)
        end
        nil
      end

      def mint_doi
        mint_ezid(Hydra::Ezid.config(:doi))
      end

      def mint_ark
        mint_ezid(Hydra::Ezid.config(:ark))
      end
    end
  end
end
