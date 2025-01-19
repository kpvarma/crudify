module CRUDify
    module Configuration
        class ColumnConfig
            attr_accessor :columns
        
            def initialize
                @columns = []
            end
        
            # Define a column with name, options, and block
            def column(name, options = {}, &block)
                @columns << { name: name, options: options, block: block }
            end

            # Retrieve columns with details for processing
            def get_columns
                @columns
            end
        end
    end
end