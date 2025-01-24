module CRUDify
  module Configuration
    class ModelVisualConfig
      attr_reader :summary_title, :summary_description, :metrics, 
                  :collection_visualisations, :entity_visualisations,
                  :collection_end_points, :entity_end_points
    
      def initialize(name)
        @summary_title = "Visual Overview of #{name.to_s.titleize}"
        @summary_description = "Explore key performance metrics and trends for #{name.to_s.titleize.pluralize}"
        @metrics = []
        @collection_visualisations = []
        @entity_visualisations = []
        @collection_end_points = []
        @entity_end_points = []
      end

      def to_h
        {
          summary_title: summary_title,
          summary_description: summary_description,
          metrics: metrics.map(&:to_h),
          collection_visualisations: collection_visualisations.map(&:to_h),
          entity_visualisations: entity_visualisations.map(&:to_h),
          # collection_end_points: collection_end_points.map { |ep| { name: ep[:name], method: ep[:method] } },
          # entity_end_points: entity_end_points.map { |ep| { name: ep[:name], method: ep[:method] } }
        }
      end

      # Set summary title
      # @param [String] title - The title for the visualisation summary
      def summary_title(title=nil)
        return @summary_title if title.nil?
        @summary_title = title
      end

      # Set summary description
      # @param [String] description - The description for the visualisation summary
      def summary_description(description=nil)
        return @summary_description if description.nil?
        @summary_description = description
      end

      # Define a metric
      # @param [String] name - The name of the metric
      # @param [Hash] options - Configuration options for the metric
      # @param [Proc] block - Optional block to further configure the metric
      def metric(name, options = {}, &block)
        metric = MetricConfig.new(name, options)
        metric.instance_eval(&block) if block_given?
        @metrics << metric
      end

      # Add a collection visualisation
      # @param [String] name - The name of the visualisation
      # @param [Hash] options - Configuration options for the visualisation
      # @param [Proc] block - Optional block to further configure the visualisation
      def add_collection_visualisation(name, options = {}, &block)
        visualisation = VisualizationConfig.new(name, options)
        visualisation.instance_eval(&block) if block_given?
        @collection_visualisations << visualisation
      end

      alias add_collection add_collection_visualisation

      # Add an entity visualisation
      # @param [String] name - The name of the visualisation
      # @param [Hash] options - Configuration options for the visualisation
      # @param [Proc] block - Optional block to further configure the visualisation
      def add_entity_visualisation(name, options = {}, &block)
        visualisation = VisualizationConfig.new(name, options)
        visualisation.instance_eval(&block) if block_given?
        @entity_visualisations << visualisation
      end

      alias add_entity add_entity_visualisation

      # Add a collection endpoint
      # @param [String] name - The name of the endpoint
      # @param [Symbol] method - HTTP method (:get, :post, etc.)
      # @param [Proc] block - Logic to be executed for the endpoint
      def add_collection_end_point(name, method: :get, &block)
        raise ArgumentError, "Block is required for #{name}" unless block_given?

        end_point_config = {
          name: name,
          method: method,
          logic: block
        }
        @collection_end_points << end_point_config
      end

      # Add an entity endpoint
      # @param [String] name - The name of the endpoint
      # @param [Symbol] method - HTTP method (:get, :post, etc.)
      # @param [Proc] block - Logic to be executed for the endpoint
      def add_entity_end_point(name, method: :get, &block)
        raise ArgumentError, "Block is required for #{name}" unless block_given?

        end_point_config = {
          name: name,
          method: method,
          logic: block
        }
        @entity_end_points << end_point_config
      end

      # Add a unified method for endpoints
      # @param [String] name - The name of the endpoint
      # @param [Symbol] ep_type - Type of endpoint (:collection, :entity)
      # @param [Symbol] method - HTTP method (:get, :post, etc.)
      # @param [Proc] block - Logic to be executed for the endpoint
      def add_end_point(name, ep_type, method: :get, &block)
        case ep_type.to_s.to_sym
        when :collection
          add_collection_end_point(name, method: method, &block)
        when :entity
          add_entity_end_point(name, method: method, &block)
        else
          raise ArgumentError, "Invalid endpoint type: #{ep_type}. Must be :collection or :entity."
        end
      end

      def collection_end_points
        @collection_end_points
      end

      def entity_end_points
        @entity_end_points
      end
    end
  end
end

