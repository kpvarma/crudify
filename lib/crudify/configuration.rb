# lib/crudify/configuration.rb
module CRUDify
  class << self
    attr_accessor :configuration

    # Delegate register methods to the configuration
    delegate :register, :register_user, to: :configuration
  end

  def self.configure
    self.configuration ||= CRUDify::Configuration::Base.new
    yield(configuration)
  end
end