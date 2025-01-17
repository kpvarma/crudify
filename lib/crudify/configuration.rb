# lib/crudify/configuration.rb
module CRUDify
  class << self
    attr_accessor :configuration

    # Delegate register methods to the configuration
    delegate :register, :register_user, to: :configuration
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :crudify_models, :crudify_user_models, :default_crud_actions, :admin_namespace

    def initialize
      @default_crud_actions = [:index, :create, :read, :update, :delete]
      @admin_namespace = "crudify_admin"
      @crudify_models = {} # Initialize an empty dict for configurable models
      @crudify_user_models = {} # Initialize an empty dict for configurable user models
    end

    # Register a CRUDify model
    def register(model_name, &block)
      # Ensure `model_name` is always a string representing the class name
      model_class_name = model_name.is_a?(String) ? model_name : model_name.name
      
      # Initialize a new ModelConfig with the class name
      model_config = ModelConfig.new(model_class_name)
      
      # Evaluate the block to configure the model if provided
      model_config.instance_eval(&block) if block_given?
    
      # Store the configuration in the dictionary using the class name as the key
      @crudify_models[model_class_name] = model_config
    end

    # Register a CRUDify user model
    def register_user(model_name, &block)
      # Ensure `model_name` is always a string representing the class name
      model_class_name = model_name.is_a?(String) ? model_name : model_name.name
      
      # Initialize a new ModelConfig with the class name
      user_config = ModelConfig.new(model_class_name)
      
      # Evaluate the block to configure the model if provided
      user_config.instance_eval(&block) if block_given?
    
      # Store the configuration in the dictionary using the class name as the key
      @crudify_user_models[model_class_name] = user_config
    end
    
  end
end