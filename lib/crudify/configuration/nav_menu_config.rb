module CRUDify
  module Configuration
    class NavMenu
      attr_accessor :type, :name, :label, :group, :parent, :priority
      def initialize(type, name, options = {})
        @type = type || :page
        @name = name
        @label = options[:label] || "Un-named Menu"
        @group = options[:group] || nil
        @parent = options[:parent] || nil
        @priority = options[:priority] || -1
      end
    end

    class NavMenuConfig
      attr_reader :menu

      def initialize()
        @menu = []
        add_home(:home, label: "Home", priority: 0)
      end

      def add_resource(name, options = {})
        add_menu(:resource, name, options)  # Pass options as a normal hash
      end

      def add_dashboard(name, options = {})
        add_menu(:dashboard, name, options)
      end

      def add_page(name, options = {})
        add_menu(:page, name, options)
      end
      
      def add_home(name, options = {})
        add_menu(:home, name, options)
      end

      def add_menu(type, name, options = {})
        nav_menu = NavMenu.new(
          type,
          name,
          label: options[:label],
          group: options[:group],
          parent: options[:parent],
          priority: options[:priority]
        )
        @menu << nav_menu
      end
      
    end
  end
end

