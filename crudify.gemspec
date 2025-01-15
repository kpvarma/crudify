require_relative "lib/crudify/version"

Gem::Specification.new do |spec|
  spec.name        = "crudify-rails"
  spec.version     = CRUDify::VERSION
  spec.authors = ["Krishna Prasad Varma"]
  spec.email = ["krshnaprsad@gmail.com"]
  spec.summary = "A dynamic CRUD gem for Rails models, supporting both Devise and custom user management."
  spec.description = "CRUDify is a dynamic Rails gem that provides CRUD operations and APIs for managing Devise-backed models and custom user models. It offers seamless integration with Next.js-based admin interfaces and aims to simplify full-stack user and model management with minimal configuration."
  spec.homepage = "https://github.com/kpvarma/crudify"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kpvarma/crudify-rails"
  spec.metadata["changelog_uri"] = "https://github.com/kpvarma/crudify/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # Dependencies
  spec.add_dependency "rails", "~> 8.0.1" # Compatible with Rails 8.0.x
  spec.add_dependency "devise", "~> 4.9.0" # Compatible with Devise 4.9.x
  
  # Dev Dependencies
  # spec.add_development_dependency 'byebug', '~> 11.1'
end