module RuGUI
  # This module defines information about routing.
  module Routing
    # Represents routes for RuGUI controllers.
    class Routes
      cattr_accessor :routing_configurations

      class << self
        # Defines routing configurations for RuGUI controllers.
        def with_routing_configurations
          @@routing_configurations ||= RouteConfiguration.new
          yield @@routing_configurations
        end
      end
    end

    # Represents the configuration about the route.
    class RouteConfiguration
      include RuGUI::LogSupport

      attr_accessor :mapping
      attr_accessor :configurations

      def initialize
        @mapping = HashWithIndifferentAccess.new
        @configurations = HashWithIndifferentAccess.new
      end

      # Defines the resources used in the RuGUI application. Basically, each
      # controller of the application should be declared in this configuration.
      def resources(controller_name, options = {})
        set_mapping(controller_name, options)
        store_configuration(controller_name, options)
      end

      protected
        def set_mapping(controller_name, options)
          if @mapping.invert[controller_name.to_sym].nil?
            position = options[:position] || (@mapping.size + 1)
            @mapping.store(position, controller_name.to_sym)
            logger.debug "Mapped a route for #{controller_name} in position #{position}."
          else
            raise "You have registered 2 routes for the same controller (#{controller_name}). Pay attention in your routes configuration and remove the duplicated configuration."
          end
        end

        def store_configuration(controller_name, options)
          @configurations.merge!({ controller_name.to_sym => options })
        end
    end
  end
end
