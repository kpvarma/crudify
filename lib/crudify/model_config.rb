module CRUDify
  class ModelConfig
    attr_accessor :name, :menu, :title, :description, :actions, :custom_actions, 
                  :list_columns, :form_columns, :per_page, :scopes, :filters
  
    def initialize(name)
      @name = name
      @menu = {}
      @title = name.to_s.titleize
      @description = "Manage #{name.to_s.titleize.pluralize}"
      @actions = []
      @custom_actions = []
      @per_page = []
      @scopes = []
      @filters = []
      @list_columns = []
      @form_columns = []
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
  
    def actions(*args)
      if args.include?(:all)
        @actions = CRUDify.configuration.default_crud_actions - Array(args.last[:except])
      else
        @actions = args
      end
    end

    def get_actions
      @actions
    end

    def custom_actions(*args)
      @custom_actions = args
    end

    def get_custom_actions
      @custom_actions
    end
  
    def per_page(value = [])
      @per_page = value
    end

    def get_per_page
      @per_page
    end
  
    def scope(name, options = {}, &block)
      @scopes << { name: name, options: options, block: block }
    end

    def get_scopes
      @scopes
    end
  
    def filter(name, options = {})
      @filters << { name: name, options: options }
    end

    def get_filters
      @filters
    end

    # DSL Method for List Columns
    def list_columns(&block)
      @list_columns = ColumnConfig.new
      @list_columns.instance_eval(&block) if block_given?
    end

    def get_list_columns
      @list_columns.columns
    end

    # DSL Method for Form Columns
    def form_columns(&block)
      @form_columns = FieldConfig.new
      @form_columns.instance_eval(&block) if block_given?
    end

    def get_form_columns
      @form_columns.columns
    end
    
  end
end