require "active_support/inflector"
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "CRUDify"
end

require "crudify/version"
require "crudify/engine"
require_relative "crudify/configurable"
require_relative "crudify/model_config"
require_relative "crudify/user_model_config"
require_relative "crudify/configuration"
require_relative "crudify/active_record_extensions"

module CRUDify
  # Your code goes here...
end
