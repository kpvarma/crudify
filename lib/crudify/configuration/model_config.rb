module CRUDify
  module Configuration
    class ModelConfig
      attr_accessor :name, :menu, :title, :description, :api_end_points, :custom_member_actions, :custom_collection_actions,
                    :list_columns, :form_fields, :records_per_page, :record_scopes, :record_filters
    
      def initialize(name)
        @name = name
        @menu = {
            "priority": -1,
            "label": "#{name.pluralize.titleize}",
            "parent": "Models"
        },
        @title = name.to_s.titleize
        @description = "Manage #{name.to_s.titleize.pluralize}"
        @api_end_points = []
        @custom_member_actions = []
        @custom_collection_actions = []
        @records_per_page = [40, 60, 100]
        @record_scopes = []
        @record_filters = []
        @list_columns = ColumnConfig.new
        @form_fields = FieldConfig.new
      end
    
      # DSL methods for configuration
      def menu(options = {})
        @menu = options
      end
      
      def get_menu
        @menu
      end

      def title(value)
        @title = value
      end

      def get_title
        @title
      end
    
      def description(value)
        @description = value
      end

      def get_description
        @description
      end
    
      def api_end_points(*args)
        # Rails.logger.tagged("CRUDify") do
        #   Rails.logger.error "setting api_end_points: #{args}"
        # end
        if args.include?(:all)
          @api_end_points = CRUDify.configuration.default_api_end_points - Array(args.last[:except])
        else
          @api_end_points = args
        end
      end

      def get_api_end_points
        @api_end_points
      end

      # Add a method to define custom API member actions
      def add_member_action(action_name, method: :get, &block)
        @custom_member_actions << { action_name: action_name, method: method, logic: block }
      end

      def get_custom_member_actions
        @custom_member_actions
      end

      # Add a method to define custom API collection actions
      def add_collection_action(action_name, method: :get, &block)
        @custom_collection_actions << { action_name: action_name, method: method, logic: block }
      end
      
      def get_custom_collection_actions
        @custom_collection_actions
      end

      def records_per_page(values = [])
        @records_per_page = values
      end

      def get_records_per_page
        @records_per_page
      end
    
      def record_scope(name, options = {}, &block)
        @record_scopes << { name: name, options: options, block: block }
      end

      def get_record_scopes
        @record_scopes
      end
    
      def record_filter(name, options = {})
        @record_filters << { name: name, options: options }
      end

      def get_record_filters
        @record_filters
      end

      # DSL Method for List Columns
      def list_columns(&block)
        @list_columns = ColumnConfig.new
        if block_given?
          @list_columns.instance_eval(&block) 
        else
          @list_columns
        end
      end

      def get_list_columns
        @list_columns&.columns
      end

      # DSL Method for Form Columns
      def form_fields(&block)
        @form_fields = FieldConfig.new
        @form_fields.instance_eval(&block) if block_given?
      end

      def get_form_fields
        @form_fields
      end
      
    end
  end
end