# lib/crudify/configuration/base.rb

require_relative "model_config"
require_relative "column_config"
require_relative "form_config"

require_relative "page_config"
require_relative "nav_menu_config"

require_relative "visual_config"
require_relative "collection_config"
require_relative "metric_config"

module CRUDify
  module Configuration
    class Base
      attr_accessor :crudify_models, :crudify_visuals, :crudify_nav_menu, 
                    :crudify_dashboards, :crudify_summary_pages, :crudify_index_pages, :crudify_reports,
                    :default_api_end_points, :exclude_models

      def initialize
        @default_api_end_points = [:index, :create, :read, :update, :delete]
        @crudify_models = {} # Initialize an empty dict for configurable models
        @crudify_visuals = {} # Initialize an empty dict for configurable models

        @crudify_dashboards = {}
        @crudify_summary_pages = {}
        @crudify_index_pages = {}
        @crudify_reports = {}
        
        @crudify_nav_menu ||= NavMenuConfig.new()
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
        
        # Initialize a new VisualConfig with the class name
        model_visual_config = VisualConfig.new(model_class_name)
        
        # Evaluate the block to configure the model if provided
        model_visual_config.instance_eval(&block) if block_given?
      
        # Store the configuration in the dictionary using the class name as the key
        @crudify_visuals[model_class_name] = model_visual_config
      end

      def configure_menu(&block)
        # Initialize a new NavMenuConfig if it isnt initialized
        @crudify_nav_menu ||= NavMenuConfig.new()
        
        # Evaluate the block to configure the model if provided
        @crudify_nav_menu.instance_eval(&block) if block_given?
      end

      def configure_dashboard(name, &block)
        # Skip registration if the model is excluded
        return unless name.is_a?(String) || name.is_a?(Symbol)
        
        # Initialize a new PageConfig with the class name
        page_config = PageConfig.new(name, :dashboard)
        
        # Evaluate the block to configure the model if provided
        page_config.instance_eval(&block) if block_given?
      
        # Store the configuration in the dictionary using the dashboard name as the key
        @crudify_dashboards[name] = page_config
      end

      def configure_summary_page(name, &block)
        # Skip registration if the model is excluded
        return unless name.is_a?(String) || name.is_a?(Symbol)
        
        # Initialize a new PageConfig with the class name
        page_config = PageConfig.new(name, :summary)
        
        # Evaluate the block to configure the model if provided
        page_config.instance_eval(&block) if block_given?
      
        # Store the configuration in the dictionary using the summary page name as the key
        @crudify_summary_pages[name] = page_config
      end

      def configure_index_page(name, &block)
        # Skip registration if the model is excluded
        return unless name.is_a?(String) || name.is_a?(Symbol)
        
        # Initialize a new PageConfig with the class name
        page_config = PageConfig.new(name, :index_page)
        
        # Evaluate the block to configure the model if provided
        page_config.instance_eval(&block) if block_given?
      
        # Store the configuration in the dictionary using the index page name as the key
        @crudify_index_pages[name] = page_config
      end

      def configure_report(name, &block)
        # Skip registration if the model is excluded
        return unless name.is_a?(String) || name.is_a?(Symbol)
        
        # Initialize a new PageConfig with the class name
        page_config = PageConfig.new(name, :report)
        
        # Evaluate the block to configure the model if provided
        page_config.instance_eval(&block) if block_given?
      
        # Store the configuration in the dictionary using the report name as the key
        @crudify_reports[name] = page_config
      end

      
      
    end
  end
end