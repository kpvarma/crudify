# lib/crudify/configuration/base.rb

require_relative "model_config"
require_relative "column_config"
require_relative "form_config"

module CRUDify
  module Configuration
    class Base
      attr_accessor :crudify_models, :default_api_end_points, :admin_namespace, :exclude_models

      def initialize
        @default_api_end_points = [:index, :create, :read, :update, :delete]
        @admin_namespace = "crudify_admin"
        @crudify_models = {} # Initialize an empty dict for configurable models
        @exclude_models = [] # Models to exclude from auto-registration
      end

      # Register a CRUDify model
      def register(model_name, &block)
        # Ensure `model_name` is always a string representing the class name
        model_class_name = model_name.is_a?(String) ? model_name : model_name.name

        # Skip registration if the model is excluded
        return if exclude_models.include?(model_class_name)
        
        # Initialize a new ModelConfig with the class name
        model_config = ModelConfig.new(model_class_name)
        
        # Evaluate the block to configure the model if provided
        model_config.instance_eval(&block) if block_given?
      
        # Store the configuration in the dictionary using the class name as the key
        @crudify_models[model_class_name] = model_config
      end
      
    end
  end
end