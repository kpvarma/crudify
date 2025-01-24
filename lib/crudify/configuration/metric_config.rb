
module CRUDify
    module Configuration
      class MetricConfig
        attr_reader :name
  
        def initialize(name, options = {})
          @name = name
          @visualisation = options[:visualisation]
          @title = options[:title] || name.to_s.titleize
          @caption = options[:caption] || "Caption for #{name}"
          @data = options[:data]
          @highlights = options[:highlights] || []
        end

        # Getter and setter for visualisation
        def visualisation(value = nil)
          return @visualisation if value.nil?
          @visualisation = value
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

  
        # Add highlight configuration for a metric
        def highlight(title:, caption: nil, value:)
          @highlights << { title: title, caption: caption, value: value }
        end

        def highlights
          @highlights
        end

        def to_h
          {
            name: name,
            visualisation: visualisation,
            title: title,
            caption: caption,
            data: data,
            highlights: highlights
          }
        end
      end
    end
  end
  