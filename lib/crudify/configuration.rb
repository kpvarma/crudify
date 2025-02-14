# lib/crudify/configuration.rb
module CRUDify
  class << self
    attr_accessor :configuration

    # Delegate register methods to the configuration
    delegate :register, :visualise, :configure_menu, to: :configuration
    delegate :configure_dashboard, :configure_summary_page, :configure_index_page, :configure_report, to: :configuration
  end

  def self.configure
    self.configuration ||= CRUDify::Configuration::Base.new
    yield(configuration)
  end
end