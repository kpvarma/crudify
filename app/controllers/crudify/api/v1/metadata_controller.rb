module CRUDify
  module Api
    module V1
      class MetadataController < ApplicationController

        before_action :authenticate_token
        before_action :get_model, only: %i[ show summary_visualisations index_visualisations show_visualisations ]

        # Index action - Render specific metadata of all models
        def index
          # Get the models for which devise auth is configured
          unless defined?(Devise) && Devise.respond_to?(:mappings) && Devise.mappings.any?
            devise_models = []
          else
            devise_models = Devise.mappings.map { |_x, y| y.class_name }
          end
        
          # Generate the models metadata
          models_metadata = CRUDify.configuration.crudify_models.map do |model_name, config|
            {
              name: model_name,
              menu: config.get_menu,
              title: config.get_title,
              description: config.get_description,
              is_devise_model: devise_models.include?(model_name),
              visual_config: CRUDify.configuration.crudify_visuals[model_name]&.to_h
            }
          end
        
          # Render the response as JSON
          render json: models_metadata, status: :ok
        end

        # Show action - Render all metadata for a particular model
        def show
          model_config = CRUDify.configuration.crudify_models[@model.name]
          
          if model_config
            render json: {
              
              model_name: @model.name,
              title: model_config.get_title,
              description: model_config.get_description,
              menu: model_config.get_menu,
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
            }, status: :ok
          else
            render json: { error: "Model #{@model.name} not found" }, status: :not_found
          end
        end

        # Renders all visualisations metadata for rendering dashboard
        def dashboard_visualisations
          vis_type = :dashboard
          visual_config = CRUDify.configuration.crudify_visuals.select{|x, y| y.collection_visualisations unless y.collection_visualisations.empty? }
          visual_metadata = visual_config.map do |model_name, visual_config|
            # visualisations = visual_config.get_visualisations(:dashboard)
            vis_data = {}
            visual_config.collection_visualisations.each do |cv|
              metrics = visual_config.metrics.select{|x| cv.metrics.include?(x.name) }.map(&:to_h)
              # metrics = visual_config.metrics.map{|x| x.to_h}
              # binding.pry
              display = cv.display[vis_type]
              next if display.nil?
              vis_data[cv.name] = {
                "title": cv.title,
                "caption": cv.caption,
                "api_end_point": cv.api_end_point,
                "hello": "world",
                "display": display,
                "metrics": metrics
              } if cv.display&.has_key?(vis_type)
            end
            {
              name: model_name,
              title: visual_config.summary_title,
              description: visual_config.summary_description,
              visualisations: vis_data,
            }
          end
        
          # Render the response as JSON
          render json: visual_metadata, status: :ok
        end

        # Renders all visualisations metadata for rendering summary page of a particular model
        def summary_visualisations
          visual_config = CRUDify.configuration.crudify_visuals[@model.name]
          
          if visual_config
            render json: {
              model_name: @model.name,
              title: visual_config.summary_title,
              description: visual_config.summary_description,
              visualisations: visual_config.get_visualisations(:summary),
            }, status: :ok
          else
            render json: { error: "Model #{@model.name} not found" }, status: :not_found
          end
        end

        # Renders all visualisations metadata for rendering index page of a particular model
        def index_visualisations
          Dir[Rails.root.join("config/crudify/**/*.rb")].each { |file| load file }
          visual_config = CRUDify.configuration.crudify_visuals[@model.name]
          
          if visual_config
            render json: {
              model_name: @model.name,
              title: visual_config.summary_title,
              description: visual_config.summary_description,
              visualisations: visual_config.get_visualisations(:index),
            }, status: :ok
          else
            render json: { error: "Model #{@model.name} not found" }, status: :not_found
          end
        end

        # Renders all visualisations metadata for rendering show page of a particular model with particular :id
        def show_visualisations
          visual_config = CRUDify.configuration.crudify_visuals[@model.name]
          
          if visual_config
            render json: {
              model_name: @model.name,
              visualisations: get_visualisations(:show),
            }, status: :ok
          else
            render json: { error: "Model #{@model.name} not found" }, status: :not_found
          end
        end

        private

        def get_model
          begin
            @model = params[:model_name].constantize
            unless @model < ActiveRecord::Base
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