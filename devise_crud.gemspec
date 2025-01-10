require_relative "lib/devise_crud/version"

Gem::Specification.new do |spec|
  spec.name        = "devise_crud"
  spec.version     = DeviseCrud::VERSION
  spec.authors = ["Krishna Prasad Varma"]
  spec.email = ["krshnaprsad@gmail.com"]
  spec.summary = "A dynamic CRUD gem for Devise-managed models in Rails."
  spec.description = "The devise_crud gem provides dynamic CRUD operations and APIs for Devise-managed models in Rails applications. It simplifies user management with minimal setup."
  spec.homepage = "https://github.com/kpvarma/devise_crud"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.1.0"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/kpvarma/devise_crud"
  spec.metadata["changelog_uri"] = "https://github.com/kpvarma/devise_crud/blob/main/CHANGELOG.md"

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  # Dependencies
  spec.add_dependency "rails", "~> 8.0.1" # Compatible with Rails 8.0.x
  spec.add_dependency "devise", "~> 4.9.0" # Compatible with Devise 4.9.x
  
  # Dev Dependencies
  # spec.add_development_dependency 'byebug', '~> 11.1'
end
