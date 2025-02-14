module CRUDify
  module Api
    module V1
      class MetadataController < ApplicationController

        before_action :authenticate_token
        before_action :get_model, only: %i[ show summary_visualisations index_visualisations show_visualisations ]

        def index
          dashboard_metadata = {}
          CRUDify.configuration.crudify_dashboards.map do |model_name, page_config|
            dashboard_metadata[model_name] = page_config.to_h
          end

          summary_page_metadata = {}
          CRUDify.configuration.crudify_summary_pages.map do |model_name, page_config|
            summary_page_metadata[model_name] = page_config.to_h
          end

          index_page_metadata = {}
          CRUDify.configuration.crudify_index_pages.map do |model_name, page_config|
            index_page_metadata[model_name] = page_config.to_h
          end

          report_metadata = {}
          CRUDify.configuration.crudify_reports.map do |model_name, page_config|
            report_metadata[model_name] = page_config.to_h
          end

          nav_menu_metadata = CRUDify.configuration.crudify_nav_menu.menu
          
          # Get the models for which devise auth is configured
          unless defined?(Devise) && Devise.respond_to?(:mappings) && Devise.mappings.any?
            devise_models = []
          else
            devise_models = Devise.mappings.map { |_x, y| y.class_name }
          end
        
          # Generate the models metadata
          models_metadata = CRUDify.configuration.crudify_models.map do |model_name, model_config|
            @model = model_name.constantize
            {
              name: model_name,
              menu: model_config.menu,
              title: model_config.title,
              summary_page: model_config.summary_page,
              description: model_config.description,
              is_devise_model: devise_models.include?(model_name),
              
              attributes: @model.attributes_metadata,
              associations: @model.associations_metadata,
              
              columns: model_config.get_list_columns,
              form_fields: model_config.get_form_fields,
              per_page: model_config.get_records_per_page,
              scopes: format_scopes(model_config.get_record_scopes),
              filters: format_filters(model_config.get_record_filters),

              api_end_points: model_config.get_api_end_points,
              custom_member_actions: model_config.get_custom_member_actions,
              custom_collection_actions: model_config.get_custom_collection_actions,
            }
          end

          # visuals_metadata = {}
          # CRUDify.configuration.crudify_visuals.map do |model_name, visual_config|
          #   visuals_metadata[model_name] = visual_config.to_h
          # end
          
          metadata ={
            nav_menu: nav_menu_metadata,
            dashboards: dashboard_metadata,
            summary_pages: summary_page_metadata,
            index_pages: index_page_metadata,
            reports: report_metadata,
            models: models_metadata,
            # visuals: visuals_metadata,
          } 
          
          # Render the response as JSON
          render json: metadata, status: :ok
        end

        # Index action - Render specific metadata of all models
        def index_old
          # Get the models for which devise auth is configured
          unless defined?(Devise) && Devise.respond_to?(:mappings) && Devise.mappings.any?
            devise_models = []
          else
            devise_models = Devise.mappings.map { |_x, y| y.class_name }
          end
        
          # Generate the models metadata
          models_metadata = CRUDify.configuration.crudify_models.map do |model_name, model_config|
            @model = model_name.constantize
            {
              model: model_name.to_s,
              visual_config: CRUDify.configuration.crudify_visuals[model_name]&.to_h,
              model_config: {
                name: model_name,
                menu: model_config.menu,
                title: model_config.title,
                summary_page: model_config.summary_page,
                description: model_config.description,
                is_devise_model: devise_models.include?(model_name),
                
                attributes: @model.attributes_metadata,
                associations: @model.associations_metadata,
                
                columns: model_config.get_list_columns,
                form_fields: model_config.get_form_fields,
                per_page: model_config.get_records_per_page,
                scopes: format_scopes(model_config.get_record_scopes),
                filters: format_filters(model_config.get_record_filters),

                api_end_points: model_config.get_api_end_points,
                custom_member_actions: model_config.get_custom_member_actions,
                custom_collection_actions: model_config.get_custom_collection_actions,
              }
            }
          end
        
          # Render the response as JSON
          render json: models_metadata, status: :ok
        end

        # Show action - Render all metadata for a particular model
        def show
          
          model_config_data = {}
          visual_config_data = {}

          model_config = CRUDify.configuration.crudify_models[@model.name]
          if model_config
            model_config_data = {
              model_name: @model.name,
              title: model_config.title,
              description: model_config.description,
              menu: model_config.menu,
              attributes: @model.attributes_metadata,
              associations: @model.associations_metadata,
              
              columns: model_config.get_list_columns,
              form_fields: model_config.get_form_fields,
              per_page: model_config.get_records_per_page,
              scopes: format_scopes(model_config.get_record_scopes),
              filters: format_filters(model_config.get_record_filters),

              api_end_points: model_config.get_api_end_points,
              custom_member_actions: model_config.get_custom_member_actions,
              custom_collection_actions: model_config.get_custom_collection_actions,
            }
          end

          visual_config = CRUDify.configuration.crudify_visuals[@model.name]
          visual_config_data = visual_config.to_h if visual_config

          data = {
            model: @model.name,
            model_config: model_config_data,
            visual_config: visual_config_data
          }

          render json: data, status: :ok
        end

        private

        def get_model
          begin
            @model = params[:model_name].constantize
            unless @model < ActiveRecord::Base || @model.include?(ActiveModel::Model)
              render json: { error: "Invalid model #{params[:model_name]}" }, status: :unprocessable_entity
              return
            end
          rescue NameError
            render json: { error: "Model #{params[:model_name]} not found" }, status: :not_found
            return
          end
        end

        # Format scopes for consistent API response
        def format_scopes(scopes)
          scopes.map do |scope|
            {
              name: scope[:name],
              label: (scope[:options] && scope[:options][:label]) || scope[:name].to_s.titleize,
              default: (scope[:options] && scope[:options][:default]) || false
            }
          end
        end

        # Format filters for consistent API response
        def format_filters(filters)
          filters.map do |filter|
            {
              field: filter[:field],
              type: filter[:type],
              label: filter[:label] || filter[:field].to_s.titleize,
              options: filter[:options]
            }
          end
        end
      end
    end
  end
end