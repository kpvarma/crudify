module CRUDify
    module Configuration
      class VisualizationConfig
        attr_reader :name
  
        def initialize(name, options = {})
          @name = name
          @collection_type = options[:collection_type]
          @metrics = options[:metrics] || []
          @api_end_point = options[:api_end_point]
          @display = options[:display] || [:summary, :index]
        end

        # Getter and setter for name
        def name(value = nil)
          return @name if value.nil?
          @name = value
        end

        # Getter and setter for collection_type
        def collection_type(value = nil)
          return @collection_type if value.nil?
          @collection_type = value
        end

        # Add a metric to the visualisation
        def metrics(value=nil)
          return @metrics if value.nil?
          @metrics = value
        end
        
        # Getter and setter for api_end_point
        def api_end_point(value = nil)
          return @api_end_point if value.nil?
          @api_end_point = value
        end
       
        # Getter and setter for display
        def display(value = nil)
          return @display if value.nil?
          @display = value
        end
  
        # Serialize visualization to hash
        def to_h
          {
            name: name,
            collection_type: collection_type,
            metrics: metrics,
            api_end_point: api_end_point,
            display: display
          }
        end
      end
    end
  end
  