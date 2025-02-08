
module CRUDify
    module Configuration
      class MetricConfig
        attr_reader :name
        
        def initialize(name, options = {})
          @name = name
          @title = options[:title] || nil
          @caption = options[:caption] || nil

          @visualisation = options[:visualisation]
          @chart = options[:chart]

          # Chart Config
          # date_format [string] -   Date display format.
          #   - `"MM/DD/YYYY"`  -> "02/25/2024"
          #   - `"MMM DD"`      -> "Feb 25"
          #   - `"YYYY-MM-DD"`  -> "2024-02-25"
          #
          # value_format [String] -   Value formatting style.
          #   ---------------------------------------------------------------------------------
          #   | Format Type   | Example Input | Example Output  | Description                 |
          #   |--------------|--------------|----------------|--------------------------------|
          #   | `"currency"` | `1500`       | `"$1,500.00"`  | Formats values as currency.    |
          #   | `"percentage"` | `0.25`      | `"25%"`        | Converts decimal to percent.  |
          #   | `"number"`   | `1234567`     | `"1,234,567"`  | Adds commas for large numbers.|
          #   | `"decimal"`  | `1234.5678`   | `"1,234.57"`   | Rounds to 2 decimal places.   |
          #   | `"scientific"` | `1000000`   | `"1.0e+6"`     | Uses scientific notation.     |
          #   | `"short"`    | `1000000`     | `"1M"`         | Converts large numbers to K/M/B.|
          #   | `"time"`     | `12345`       | `"3h 25m"`     | Converts into hours & minutes.|
          #   | `"custom"`   | `1234.5678`   | `"Custom Format"` | Allows custom function.    |
          #   --------------------------------------------------------------------------------
          #
          # theme [String] -   Chart theme (`"light"` or `"dark"`).
          # Custom colors for chart series (e.g., `["#FF5733", "#33FF57", "#3357FF"]`).
          #
          @chart_config = options[:chart_config] || {}

          @chart_config[:title] = @title
          @chart_config[:caption] = @caption
          
          # Chart Behavior
          @chart_config[:legend] = true
          @chart_config[:tooltip] = true
          @chart_config[:grid] = true
          @chart_config[:animation] = true
          @chart_config[:height] = 200

          @chart_config[:date_format] = "%b %d"
          @chart_config[:value_format] = "short"
          @chart_config[:decimal_places] = 2

          @chart_config[:hide_x_axis] = false
          @chart_config[:hide_y_axis] = false

          @chart_config[:theme] = "light"
          @chart_config[:colors] = ["#4B4B4B", "#FF6B6B", "#007BFF", "#FFBF00", "#6A0DAD", "#708090"]

          @data = options[:data]
          @measures = options[:measures] || []
          @highlights = options[:highlights] || []
        end

        # Getter and setter for visualisation
        def visualisation(value = nil)
          return @visualisation if value.nil?
          @visualisation = value
        end
        
        # Getter and setter for chart
        def chart(type = nil, **options)
          return @chart if type.nil?
          @chart = type

          @chart_config[:title] = options[:title] || @title
          @chart_config[:caption] = options[:caption] || @caption
          
          # Chart Behavior
          @chart_config[:legend] = options[:legend] || true
          @chart_config[:tooltip] = options[:tooltip] || true
          @chart_config[:grid] = options[:grid] || true
          @chart_config[:animation] = options[:animation] || true
          @chart_config[:height] = options[:height] || 200

          @chart_config[:date_format] = options[:date_format] || "%b %d"
          @chart_config[:value_format] = options[:value_format] || "short"
          @chart_config[:decimal_places] = options[:decimal_places] || 2

          @chart_config[:hide_x_axis] = options[:hide_x_axis] || false
          @chart_config[:hide_y_axis] = options[:hide_y_axis] || false

          @chart_config[:theme] = options[:theme] || "light"
          @chart_config[:colors] = options[:colors] || ["#4B4B4B", "#FF6B6B", "#007BFF", "#FFBF00", "#6A0DAD", "#708090"]
        end

        def chart_config
          @chart_config
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

        # Getter and setter for data
        def data(value = nil)
          return @data if value.nil?
          @data = value
        end

        # Getter and setter for data
        def highlights(value = nil)
          return @highlights if value.nil?
          @highlights = value
        end
  
        # Add highlight configuration for a metric
        def highlight(title:, caption: nil, value:)
          @highlights << { title: title, caption: caption, value: value }
        end

        # Getter and setter for data
        def measures(value = nil)
          return @measures if value.nil?
          @measures = value
        end
  
        # Add measure configuration for a metric
        def measure(label:, hover: nil, value:)
          @measures << { label: label, hover: hover, value: value }
        end

        def to_h
          {
            name: name,
            title: title,
            caption: caption,
            visualisation: visualisation,
            chart: chart,
            chart_config: @chart_config.merge({title: title, caption: caption}),
            data: data,
            measures: @measures,
            highlights: @highlights
          }
        end
      end
    end
  end
  