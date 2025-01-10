module DeviseCrud
  class Engine < ::Rails::Engine
    isolate_namespace DeviseCrud
    config.generators.api_only = true
  end
end
