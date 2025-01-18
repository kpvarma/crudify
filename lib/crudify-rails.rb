require "active_support/inflector"
ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym "CRUDify"
end

require "crudify/version"
require "crudify/engine"
require_relative "crudify/configuration"
require_relative "crudify/configuration/base"
require_relative "crudify/configurable"
require_relative "crudify/active_record_extensions"

module CRUDify
  # Your code goes here...
end
