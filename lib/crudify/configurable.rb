module CRUDify
  module Configurable
    extend ActiveSupport::Concern

    included do
      # Define a class-level attribute to store CRUDify configurations
      class_attribute :crudify_config, instance_writer: false

      # Use the Configuration class to register models
      # after_initialize do
      #   # Skip if the model is in the excluded list or already registered
      #   unless CRUDify.configuration.exclude_models.include?(model_name) || CRUDify.configuration.crudify_models.key?(model_name)
      #     CRUDify.configuration.register(model_name)
      #   end
      # end
    end

    class_methods do
      # Define a method to configure a model for CRUDify
      def crudify(options = {}, &block)
        CRUDify.configuration.register(self.name) do |model_config|
          # Merge options and apply block configurations
          default_config = {
            name: self.name.pluralize.titleize,
            menu: { priority: 10, label: self.name.pluralize},
            title: "#{name.pluralize.titleize}",
            description: "Manage #{name.pluralize}",
            api_end_points: CRUDify.configuration.default_api_end_points,
            custom_api_end_points: [],
            records_per_page: 40,
            record_scopes: [],
            record_filters: [],
            list_columns: [],
            form_fields: []
          }
          # Merge options into the configuration object
          model_config.name = default_config[:name]
          model_config.menu = default_config[:menu].merge(options[:menu] || {})
          model_config.title = default_config[:title].merge(options[:title] || {})
          model_config.description = default_config[:description].merge(options[:description] || {})
          model_config.api_end_points = options[:api_end_points] || default_config[:api_end_points]
          model_config.custom_api_end_points = options[:custom_api_end_points] || default_config[:custom_api_end_points]
          model_config.records_per_page = options[:records_per_page] || default_config[:records_per_page]
          model_config.record_scopes = options[:record_scopes] || default_config[:record_scopes]
          model_config.record_filters = options[:record_filters] || default_config[:record_filters]
          model_config.list_columns = options[:list_columns] || default_config[:list_columns]
          model_config.form_fields = options[:form_fields] || default_config[:form_fields]

          # Apply any additional custom block
          block.call(model_config) if block_given?
        end
      end
    end
  end
end