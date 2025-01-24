require 'pry'

module CRUDify
  class Engine < ::Rails::Engine
    isolate_namespace CRUDify
    config.generators.api_only = true

    # Add inflections
    initializer "crudify.add_inflections" do
      ActiveSupport::Inflector.inflections(:en) do |inflect|
        inflect.acronym 'CRUDify'
      end
    end

    # Append migrations from the engine to the host app
    initializer :append_migrations do |app|
      unless app.root.to_s.match?(root.to_s)
        app.config.paths["db/migrate"].concat(config.paths["db/migrate"].expanded)
      end
    end

    # Configure generators
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.template_engine :erb
      g.orm :active_record, primary_key_type: :uuid
    end

    # Add ActiveRecord hooks to include Configurable module and ActiveRecordExtensions
    initializer "crudify.add_active_record_hooks" do
      ActiveSupport.on_load(:active_record) do
        include CRUDify::ActiveRecordExtensions
        include CRUDify::Configurable
      end
    end

    initializer "crudify.initialize_configuration" do
      CRUDify.configure do |config|
        # Optional: Set default configurations here
        config.default_api_end_points = [:index, :create, :read, :update, :delete]
        config.admin_namespace = "crudify_admin"
        config.crudify_models = {} # Ensure the crudify_models hash is initialized
        config.crudify_visuals = {} # Ensure the crudify_models hash is initialized
        config.exclude_models = [] # Allow the host app to modify this
      end
    end

    # initializer "crudify.auto_register_models" do
    #   Rails.application.config.after_initialize do
    #     ActiveRecord::Base.descendants.each do |model|
    #       next if model.abstract_class? || CRUDify.configuration.exclude_models.include?(model.name)
    #       unless CRUDify.configuration.crudify_models.key?(model.name)
    #         Rails.logger.tagged("CRUDify") do
    #           Rails.logger.info "Auto-registering model #{model.name}"
    #         end
    #         CRUDify.configuration.register(model.name)
    #       end
    #     end
    #   end
    # end

    # Ensure engine configuration is initialized
    initializer "crudify.load_model_configs" do |app|
      Rails.application.config.after_initialize do
        config_path = Rails.root.join("config", "crudify")

        if Dir.exist?(config_path)
          Rails.logger.tagged("CRUDify") do
            Rails.logger.debug "Loading configurations from #{config_path}"
          end
          
          # Require each Ruby file in the directory
          Dir.glob(config_path.join("*.rb")).each do |file|
            Rails.logger.tagged("CRUDify") do
              Rails.logger.debug "Loaded configuration from file #{file}"
            end
            begin
              require_dependency file
            rescue StandardError => e
              Rails.logger.tagged("CRUDify") do
                Rails.logger.error "Failed to load configuration file #{file}. Error: #{e.message}"
                Rails.logger.error "Backtrace:\n#{e.backtrace.join("\n")}"
              end
            end
          end
        else
          Rails.logger.tagged("CRUDify") do
            Rails.logger.warn "No model configurations found at #{config_path}. Skipping."
          end
        end
      end
    end

  end
end