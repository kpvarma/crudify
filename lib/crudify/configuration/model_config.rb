module CRUDify
  module Configuration
    class ModelConfig
      attr_accessor :name, :menu, :title, :description, :api_end_points, :custom_member_actions, :custom_collection_actions,
                    :list_columns, :form_fields, :records_per_page, :record_scopes, :record_filters, :summary_page
      
      RESTRICTED_COLUMN_NAMES = [
        # Security & Authentication
        "password", "password_digest", "token", "secret", "api_key", "apikey",
        "auth", "authentication", "credentials", "session", "otp", "two_factor",
      
        # Encryption & Privacy
        "encrypt", "encrypted_", "decrypted_", "hash", "salt", "private", "key",
        "certificate", "fingerprint", "digital_signature",
      
        # Personally Identifiable Information (PII)
        "ssn", "social_security", "dob", "date_of_birth", "birthdate",
        "phone", "mobile", "email", "contact", "address", "city", "state",
        "zipcode", "postal", "country", "geo", "location", "lat", "long",
      
        # System & Meta Columns
        "id", "uuid", "slug", "unique_identifier", "reference", "guid", "system",
        "deleted_at", "archived_at", "modified_at", "log", "audit", "trace", "metadata", "revision", "history",
      
        # Files & Attachments
        "image", "photo", "avatar", "picture", "video", "attachment", "document",
        "file", "filename", "filepath", "mime", "mimetype", "blob", "binary",
      
        # Descriptions & Large Text Fields
        "description", "long_text", "content", "summary", "comments", "notes",
        "remark", "bio", "details", "html", "markdown", "body", "post", "message"
      ]

      def initialize(name)
        @name = name
        @model_class = @name.constantize
        # @menu = {
        #     "priority": -1,
        #     "label": "#{name.pluralize.titleize}",
        #     "parent": "Models"
        # }
        # @title = name.to_s.titleize
        # @description = "Manage #{name.to_s.titleize.pluralize}"
        @api_end_points = []
        @custom_member_actions = []
        @custom_collection_actions = []
        @records_per_page = []
        @record_scopes = []
        @record_filters = []
        @columns_to_exclude = []
        # @list_columns = ColumnConfig.new
        @form_fields = FieldConfig.new
        @summary_page = nil

        # Initialize with default config values
        set_default_config
      end

      def set_default_config
        # Menu
        menu priority: -1, label: "#{name.pluralize.titleize}", parent: "Models"

        title name.to_s.titleize
        description "Manage #{name.to_s.titleize.pluralize}"

        # Index Page - Actions
        api_end_points :all, except: [:destroy]
        
        # Index Page - Pagination
        records_per_page = [40, 60, 100]

        # Index Page - Scopes
        record_scope :all

        # Set default columns
        set_default_columns
      end

      def set_default_columns
        @list_columns = ColumnConfig.new

        return unless @model_class.respond_to?(:columns)

        # Adding the default id column
        # @list_columns.column :id, label: "ID", type: :id do |record|
        #   record.id
        # end

        # Adding a record column to display the records name
        @list_columns.column :record, label: name.to_s.titleize, type: :record do |record|
          if @model_class.instance_methods.include?(:display_name)
            record.send(:display_name)
          else
            "#{name.to_s.titleize} ##{record.id}"
          end
        end
        
        @model_class.columns.each do |col|

          # Excluding id as it is already added
          next if col.name == "id"

          # Excluding the column if it has restricted words
          rst_flag = false
          RESTRICTED_COLUMN_NAMES.each do |rst_word|
            rst_flag = true if col.name.include?(rst_word)
          end
          next if rst_flag
          
          # Excluding the columns configured to be excluded
          next if @columns_to_exclude.map(&:to_s).include?(col.name.to_s)

          case col.type.to_s
          when "date"
            @list_columns.column col.name, label: "#{col.name.to_s.titleize}", type: :date do |record|
              record.send(col.name)&.strftime("%-d %b %Y")
            end
          when "datetime"
            @list_columns.column col.name, label: "#{col.name.to_s.titleize}", type: :datetime do |record|
              record.send(col.name)&.strftime("%-d %b %Y, %I:%M %p")
            end
          when "string"
            # Check if the column is an enum
            if @model_class.defined_enums.key?(col.name.to_s)
              @list_columns.column col.name, label: "#{col.name.to_s.titleize}", type: :enum do |record|
                record.send(col.name)&.titleize  # Fetch enum's readable name
              end
            else
              @list_columns.column col.name, label: "#{col.name.to_s.titleize}", type: :string do |record|
                record.send(col.name)
              end
            end
          when "integer"
            # Check if the column is a reference (foreign key)
            if col.name.to_s.end_with?("_id")
              association_name = col.name.to_s.sub(/_id$/, '')  # Extract association name (e.g., "course" from "course_id")
              association = @model_class.reflect_on_association(association_name.to_sym)
          
              if association && association.macro == :belongs_to
                @list_columns.column association_name, label: "#{association_name.titleize}", type: :reference do |record|
                  associated_record = record.send(association_name)  # Dynamically fetch related record
                  if associated_record&.respond_to?(:display_name)
                    associated_record&.send(:display_name)
                  else
                    "#{association_name.titleize} " + associated_record&.send(:id).to_s
                  end
                end
              else
                @list_columns.column col.name, label: "#{col.name.to_s.titleize}", type: :integer do |record|
                  record.send(col.name)
                end
              end
            else
              @list_columns.column col.name, label: "#{col.name.to_s.titleize}", type: :integer do |record|
                record.send(col.name)
              end
            end
          else
            @list_columns.column col.name, label: "#{col.name.to_s.titleize}", type: col.type do |record|
              record.send(col.name)
            end
          end
        end
      end

      # Getter and setter for menu
      def menu(value = nil)
        return @menu if value.nil?
        @menu = value
      end

      # Getter and setter for title
      def title(value = nil)
        return @title if value.nil?
        @title = value
      end

      # Getter and setter for description
      def description(value = nil)
        return @description if value.nil?
        @description = value
      end
      
      # Getter and setter for summary_page
      def summary_page(value = nil)
        return @summary_page if value.nil?
        @summary_page = value
      end
    
      def api_end_points(*args)
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
        @record_scopes << { name: name.to_s, options: options, block: block }
      end

      def get_record_scopes
        @record_scopes
      end
    
      def record_filter(name, options = {})
        @record_filters << { name: name.to_s, options: options }
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

      # Getter and setter for columns_to_exclude
      def columns_to_exclude(value = nil)
        return @columns_to_exclude if value.nil?
        @columns_to_exclude = value.map(&:to_s)
        @columns_to_exclude.each do |col_name|
          @list_columns.remove_column(col_name)
        end
      end
      alias exclude_columns columns_to_exclude

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