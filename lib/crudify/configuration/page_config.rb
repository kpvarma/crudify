module CRUDify
  module Configuration
    class PageConfig
      attr_reader :page_type, :name, :title, :description, :widgets

      def initialize(name, page_type, options={})
        @name = name
        @page_type = page_type
        @title = options[:title] || "#{@page_type.to_s.titleize} - #{@name} - #{@page_type}"
        @description = options[:title] || "#{@page_type.to_s.titleize} configured for #{@name}"
        @widgets = []
      end

      # Set page_type
      # @param [String] page_type - The page_type for the dashboard
      def page_type(page_type=nil)
        return @page_type if page_type.nil?
        @page_type = page_type
      end

      # Set title
      # @param [String] title - The title for the dashboard
      def title(title=nil)
        return @title if title.nil?
        @title = title
      end

      # Set description
      # @param [String] description - The description for the dashboard
      def description(description=nil)
        return @description if description.nil?
        @description = description
      end

      # Add a collection endpoint
      # @param [String] name - The name of the endpoint
      # @param [Hash] options hash - 
      # e.g: add_widget model: "Student", collection: :active_status_counts, position: x: 0, y: 0, w: 3, h: 4
      def add_widget(options={})
        widget = {
          model: options[:model],
          collection: options[:collection],
          position: options[:position],
          refresh_interval: options[:refresh_interval]
        }
        @widgets << widget
      end
      alias show_widget add_widget

      def to_h
        widget_list = []
        @widgets.each do |w|
          model_visuals = CRUDify.configuration.crudify_visuals[w[:model]]
          next unless model_visuals
          
          # Unpacking Collections and its metrices
          collection = model_visuals.collection_visualisations.find { |x| x.name == w[:collection] }&.to_h
          next unless collection
          collection_hsh = {
            name: collection[:name],
            title: collection[:title],
            caption: collection[:caption],
            api_end_point: collection[:api_end_point],
            metrics: [],
          }
          collection[:metrics].each do |metric_name|
            collection_hsh[:metrics] << model_visuals.metrics.find { |x| x.name == metric_name }&.to_h
          end

          widget_list << {
            model: w[:model],  
            position: w[:position],  
            refresh_interval: w[:refresh_interval],  
            collection: collection_hsh  
          }
        end
        {
          name: @name,
          page_type: @page_type,
          title: @title,
          description: @description,
          widgets: widget_list
        }
      end

      # FIXME - this is not used now. need to start using this function for validating the values 
      def valid_display_structure?(value)
        unless (value.is_a?(Hash) && value.keys.sort == [:h, :w, :x, :y] && value.values.all? { |v| v.is_a?(Integer) && v >= 0 })
          raise ArgumentError, "Invalid display format. Must be a hash with valid keys and {x, y, w, h} values."
        end  
      end
      
    end
  end
end

