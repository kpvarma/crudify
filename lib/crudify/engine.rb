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

    # Add ActiveRecord hooks to include Configurable module
    initializer "crudify.add_active_record_hooks" do
      ActiveSupport.on_load(:active_record) do
        include CRUDify::Configurable
      end
    end

    initializer "crudify.extend_active_record" do
      ActiveSupport.on_load(:active_record) do
        include CRUDify::ActiveRecordExtensions
      end
    end

    initializer "crudify.initialize_configuration" do
      CRUDify.configure do |config|
        # Optional: Set default configurations here
        config.default_crud_actions = [:index, :create, :read, :update, :delete]
        config.admin_namespace = "crudify_admin"
        config.crudify_models = {} # Ensure the crudify_models hash is initialized
        config.crudify_user_models = {} # Ensure the crudify_user_models hash is initialized
      end
    end

    # Ensure engine configuration is initialized
    initializer "crudify.load_model_configs" do |app|
      Rails.application.config.after_initialize do
        config_path = Rails.root.join("config", "crudify")

        Rails.logger.info "CRUDify: Rails application class: #{Rails.application.class}"
        Rails.logger.info "CRUDify: config_path: #{config_path}"
        Rails.logger.info "CRUDify: Rails.root: #{Rails.root}"

        if Dir.exist?(config_path)
          Rails.logger.info "CRUDify: Loading configurations from #{config_path}"
          
          # Require each Ruby file in the directory
          Dir.glob(config_path.join("*.rb")).each do |file|
            Rails.logger.info "CRUDify: Loading configuration file #{file}"
            begin
              require_dependency file
            rescue StandardError => e
              Rails.logger.error "CRUDify: Failed to load configuration file #{file}. Error: #{e.message}"
            end
          end
        else
          Rails.logger.warn "CRUDify: No model configurations found at #{config_path}. Skipping."
        end
      end
    end

  end
end