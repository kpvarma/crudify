module CRUDify
    module Configuration
        class ColumnConfig
            attr_accessor :columns
        
            def initialize
            @columns = []
            end
        
            def column(details)
            @columns << details
            end
        end
    end
end