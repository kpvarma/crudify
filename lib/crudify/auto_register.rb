module CRUDify
  module AutoRegister
    def self.run
      Rails.logger.tagged("CRUDify") { Rails.logger.debug "Running auto-registration..." }

      ActiveRecord::Base.descendants.each do |model|
        next if model.abstract_class?

        # Check if the model has a corresponding database table
        next unless model.table_exists?

        if CRUDify.configuration.exclude_models.include?(model.name)
          Rails.logger.tagged("CRUDify") { Rails.logger.debug "Skipping Model #{model.name}" }
          next
        end

        unless CRUDify.configuration.crudify_models.key?(model.name)
          Rails.logger.tagged("CRUDify") { Rails.logger.debug "Auto-registering Model #{model.name}" }

          # Register the model in CRUDify
          CRUDify.configuration.register(model.name) do
            description "Listing all records"
          end

          # Register visualization for the model
          CRUDify.configuration.visualise(model.name)
        end
      end
    end
  end
end