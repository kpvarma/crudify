module CRUDify
    module Configuration
        class ColumnConfig
            attr_accessor :columns
        
            def initialize
                @columns = []
            end
        
            # Define a column with name, options, and block
            def column(name, options = {}, &block)
                @columns << { name: name.to_s, options: options, block: block }
            end

            # Remove a column
            def remove_column(name)
                @columns.reject! { |col| col[:name] == name } if name
            end

            # Retrieve columns with details for processing
            def get_columns
                @columns
            end
        end
    end
end