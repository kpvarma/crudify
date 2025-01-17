module CRUDify
    module ActiveRecordExtensions
        extend ActiveSupport::Concern

        class_methods do
            # Method to fetch metadata for attributes
            def attributes_metadata
                columns.map do |column|
                {
                    name: column.name,
                    type: column.type.to_s,
                    nullable: column.null,
                    default: column.default,
                    # limit: column.limit,
                    # precision: column.precision,
                    # scale: column.scale
                }
                end
            end

            # Method to fetch metadata for associations
            def associations_metadata
                reflect_on_all_associations.map do |association|
                {
                    name: association.name.to_s,
                    type: association.macro.to_s,
                    class_name: association.klass.name,
                    foreign_key: association.foreign_key,
                    primary_key: association.active_record_primary_key,
                    optional: association.options[:optional] || false,
                    polymorphic: association.polymorphic?
                }
                end
            end
        end
    end
end