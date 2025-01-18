module CRUDify
    module Configuration
        class FieldConfig
            attr_accessor :fields
        
            def initialize
            @fields = []
            end
        
            def field(name, options = {})
            @fields << options.merge(name: name)
            end
        end
    end
end