# lib/crudify/configuration/base.rb

require_relative "model_config"
require_relative "column_config"
require_relative "form_config"

require_relative "model_visual_config"
require_relative "collection_config"
require_relative "metric_config"

module CRUDify
  module Configuration
    class Base
      attr_accessor :crudify_models, :crudify_visuals, :default_api_end_points, :exclude_models

      def initialize
        @default_api_end_points = [:index, :create, :read, :update, :delete]
        @crudify_models = {} # Initialize an empty dict for configurable models
        @crudify_visuals = {} # Initialize an empty dict for configurable models
        @exclude_models = [] # Models to exclude from auto-registration
      end

      # Register a CRUDify model
      def register(model_name, &block)
        # Ensure `model_name` is always a string representing the class name
        model_class_name = model_name.is_a?(String) ? model_name : model_name.name

        # Skip registration if the model is excluded
        return if exclude_models.include?(model_class_name)
        return if model_class_name == "CRUDify::ApiKey"
        
        # Initialize a new ModelConfig with the class name
        model_config = ModelConfig.new(model_class_name)
        
        # Evaluate the block to configure the model if provided
        model_config.instance_eval(&block) if block_given?
      
        # Store the configuration in the dictionary using the class name as the key
        @crudify_models[model_class_name] = model_config
      end

      # Register visualisation with a model
      def visualise(model_name, &block)
        # Ensure `model_name` is always a string representing the class name
        model_class_name = model_name.is_a?(String) ? model_name : model_name.name

        # Skip registration if the model is excluded
        return if exclude_models.include?(model_class_name)
        return if model_class_name == "CRUDify::ApiKey"
        
        # Initialize a new ModelVisualConfig with the class name
        model_visual_config = ModelVisualConfig.new(model_class_name)
        
        # Evaluate the block to configure the model if provided
        model_visual_config.instance_eval(&block) if block_given?
      
        # Store the configuration in the dictionary using the class name as the key
        @crudify_visuals[model_class_name] = model_visual_config
      end
      
    end
  end
end