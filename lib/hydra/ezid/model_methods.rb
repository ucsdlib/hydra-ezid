module Hydra
  module Ezid
    module ModelMethods
      extend ActiveSupport::Concern

      included do
        def self.ezid_registry
          @@ezid_registry ||= {}
        end
        def self.ezid_config(&block)
          block.call
        end
        def self.doi(options)
          ezid_register(options, :doi)
        end
        def self.ark(options)
          ezid_register(options, :ark)
        end
        # TODO: include stuff such as AF callbacks and validations
        private
        def self.ezid_register(options, scheme)
          datastream = options[:at]
          field = options.fetch(:in, scheme)
          ezid_registry[scheme] = {datastream: datastream, field: field}
        end
      end

      # TODO: This will be done by ezid gem, THROW AWAY
      def idify(*ary)
        "#{ary[0]}:/#{ary[1]}/#{ary[2]}#{ary[3]}"
      end

      def mint_ezid!(conf = Hydra::Ezid.configurator)
        raise Hydra::Ezid::MintError.new("Cannot mint EZID until object is saved") unless self.persisted?
        self.class.ezid_registry.each_pair do |scheme, opts|
          # TODO: This sucks. Needs DRY. Replace with e.g., conf.send().whatever
          case scheme
          when :doi
            id = idify(conf.doi.scheme, conf.doi.naa, conf.doi.shoulder, self.pid)
          when :ark
            id = idify(conf.ark.scheme, conf.ark.naa, conf.ark.shoulder, self.pid)
          end
          datastreams["#{opts[:datastream]}"].send("#{opts[:field]}=", id)
        end
        # TODO: When generate_ezid is ready, fix me with something like:
        #   session = ::Ezid::ApiSession.new(
        #     conf.doi.user,
        #     conf.doi.pass,
        #     conf.doi.scheme,
        #     conf.doi.naa
        #  )
        #  @ezid = session.generate_ezid(conf.doi.shoulder + self.pid)
        nil
      end
    end
  end
end
