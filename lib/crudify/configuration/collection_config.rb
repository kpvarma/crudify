module CRUDify
    module Configuration
      class CollectionConfig
        attr_reader :name
  
        def initialize(name, options = {})
          @name = name
          @title = nil
          @caption = nil
          @metrics = options[:metrics] || []
          @api_end_point = options[:api_end_point]
        end

        # Getter and setter for name
        def name(value = nil)
          return @name if value.nil?
          @name = value
        end

        # Getter and setter for title
        def title(value = nil)
          return @title if value.nil?
          @title = value
        end

        # Getter and setter for caption
        def caption(value = nil)
          return @caption if value.nil?
          @caption = value
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
        
        # Serialize visualization to hash
        def to_h
          {
            name: name,
            title: title,
            caption: caption,
            metrics: metrics,
            api_end_point: api_end_point
          }
        end

        private
        
      end
    end
  end
  