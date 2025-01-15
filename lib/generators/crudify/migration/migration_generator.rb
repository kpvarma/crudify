module CRUDify
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def copy_migration
        timestamp = Time.now.utc.strftime("%Y%m%d%H%M%S")
        migration_filename = "#{timestamp}_create_api_keys.rb"
        template "create_api_keys.rb", "db/migrate/#{migration_filename}"
        puts "Generated migration: db/migrate/#{migration_filename}"
      end
    end
  end
end