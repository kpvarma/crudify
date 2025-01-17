module CRUDify
  module Configurable
    extend ActiveSupport::Concern

    included do
      # Define a class-level attribute to store CRUDify configurations
      class_attribute :crudify_config, instance_writer: false

      # Use the Configuration class to register models
      after_initialize do
        CRUDify.configuration.register(self.class.name) unless CRUDify.configuration.crudify_models.key?(self.class.name)
      end
    end

    class_methods do
      # Define a method to configure a model for CRUDify
      def crudify(options = {}, &block)
        CRUDify.configuration.register(self.name) do |model_config|
          # Merge options and apply block configurations
          default_config = {
            name: self.name.pluralize.titleize,
            menu: { priority: 10, label: self.name.pluralize },
            actions: CRUDify.configuration.default_crud_actions,
            per_page: 20,
            scopes: [],
            filters: []
          }
          # Merge options into the configuration object
          model_config.name = default_config[:name]
          model_config.menu = default_config[:menu].merge(options[:menu] || {})
          model_config.actions = options[:actions] || default_config[:actions]
          model_config.per_page = options[:per_page] || default_config[:per_page]
          model_config.scopes = options[:scopes] || default_config[:scopes]
          model_config.filters = options[:filters] || default_config[:filters]

          # Apply any additional custom block
          block.call(model_config) if block_given?
        end
      end

      def crudify_user(options = {}, &block)
        CRUDify.configuration.register_user(self.name) do |user_config|
          default_config = {
            title: self.name.pluralize.titleize,
            actions: CRUDify.configuration.default_crud_actions,
            custom_options: {}
          }
          # Merge options into the user configuration object
          user_config.title = options[:title] || default_config[:title]
          user_config.actions = options[:actions] || default_config[:actions]
          user_config.custom_options = options[:custom_options] || default_config[:custom_options]

          # Apply any additional custom block
          block.call(user_config) if block_given?
        end
      end
    end
  end
end