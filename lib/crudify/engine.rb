module CRUDify
  class Engine < ::Rails::Engine
    isolate_namespace CRUDify
    config.generators.api_only = true

    # Enable migrations
    initializer :append_migrations do |app|
      unless app.root.to_s.match?(root.to_s)
        app.config.paths["db/migrate"].concat(config.paths["db/migrate"].expanded)
      end
    end

    # Ensure generators work inside the gem
    config.generators do |g|
      g.test_framework :rspec, fixture: false
      g.template_engine :erb
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
