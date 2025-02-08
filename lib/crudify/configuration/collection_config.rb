module CRUDify
    module Configuration
      class CollectionConfig
        attr_reader :name, :display, :refresh_interval
  
        def initialize(name, options = {})
          @name = name
          @title = nil
          @caption = nil
          @metrics = options[:metrics] || []
          @api_end_point = options[:api_end_point]
          @display = Hash.new()
          @refresh_interval = 0
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
        
        # Getter and setter for refresh_interval
        def refresh_interval(value = nil)
          return @refresh_interval if value.nil?
          @refresh_interval = value
        end
       
        # Getter and setter for display
        def display_on_dashboard(x: 0, y: 0, w: 12, h: 2)
          value = { x: x, y: y, w: w, h: h }
          valid_display_structure?(value)
          @display[:dashboard] = value
        end

        def display_on_summary(x: 0, y: 0, w: 12, h: 2)
          value = { x: x, y: y, w: w, h: h }
          valid_display_structure?(value)  
          @display[:summary] = value  
        end

        def display_on_index(x: 0, y: 0, w: 12, h: 2)
          value = { x: x, y: y, w: w, h: h }
          valid_display_structure?(value)
          @display[:index] = value
        end

        def display_on_show(x: 0, y: 0, w: 12, h: 2)
          value = { x: x, y: y, w: w, h: h }  
          valid_display_structure?(value)
          @display[:show] = value
        end
        
        # Serialize visualization to hash
        def to_h
          {
            name: name,
            title: title,
            caption: caption,
            metrics: metrics,
            api_end_point: api_end_point,
            display: display
          }
        end

        private
        
        def valid_display_structure?(value)
          unless (value.is_a?(Hash) && value.keys.sort == [:h, :w, :x, :y] && value.values.all? { |v| v.is_a?(Integer) && v >= 0 })
            raise ArgumentError, "Invalid display format. Must be a hash with valid keys and {x, y, w, h} values."
          end  
        end
      end
    end
  end
  