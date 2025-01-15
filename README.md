# DeviseCrud Gem

DeviseCrud is a lightweight and flexible Ruby on Rails gem that extends Devise by exposing APIs for managing Devise-powered user models. This gem is designed for developers looking to build a seamless CRUD (Create, Read, Update, Delete) functionality for their Devise-managed models without requiring any UI integration.

The gem is especially useful when paired with next-admin, a Next.js frontend application designed to consume these APIs and provide a user-friendly interface for managing your Devise-powered user types.

## Features

* API-Only Design: No UI provided; instead, RESTful APIs are exposed to interact with Devise models.
* Dynamic User Management: Automatically generates CRUD APIs for all Devise-managed user models.
* Secure API Key Validation: API endpoints are protected with API key authentication for secure access.
* Extendable Architecture: Allows customization and extension to meet application-specific requirements.
* Rails-Admin Alternative: Serves as the backend counterpart for next-admin, enabling an admin-like interface for your Rails app.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'devise_crud'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install devise_crud
```

## Setup

1. Add Devise to Your Application:
   Ensure you have Devise configured for your application.

2. Mount the DeviseCrud Engine:
   Add the following line to your config/routes.rb file:

   ```ruby
   mount DeviseCrud::Engine, at: "/devise_crud"
   ```

3. API Key Validation:
   Configure the API key mechanism in your environment variables for secure access to the APIs.

## Available APIs

The DeviseCrud gem exposes the following key API endpoints:

### General APIs

* Health Check: `/devise_crud/api/v1/health`
  Validates the availability of the gem.
* API Key Validation: `/devise_crud/api/v1/validate_api_key`
  Verifies the authenticity of the provided API key.

### User Management

* Get All User Types: `/devise_crud/api/v1/user_types`
  Retrieves all Devise-managed user types and their attributes, devise features, and routes.

### CRUD APIs for User Types

Dynamic CRUD APIs are generated for each Devise-managed user type. For example, if you have Student and Teacher models managed by Devise, the following routes are available:

Example for Student:

* Index: `/devise_crud/api/v1/user_type_crud/student/` (GET)
  Lists all students.
* Show: `/devise_crud/api/v1/user_type_crud/student/:id` (GET)
  Fetches a single student by ID.
* Create: `/devise_crud/api/v1/user_type_crud/student/` (POST)
  Creates a new student.
* Update: `/devise_crud/api/v1/user_type_crud/student/:id` (PUT/PATCH)
  Updates an existing student.
* Destroy: `/devise_crud/api/v1/user_type_crud/student/:id` (DELETE)
  Deletes a student by ID.

Similar routes are created for other user types such as Teacher.

## Usage

This gem does not provide any UI functionality. To interact with the APIs, you can use Postman, Insomnia, or integrate it with next-admin. The recommended way to explore and manage your Devise models is by using next-admin, a Next.js-based frontend admin panel designed to work seamlessly with the DeviseCrud gem.

### Using next-admin

* Next-Admin Repository: Link to next-admin repo
* Install and configure the frontend to point to your backend API (`/devise_crud`).
* Experience a dynamic and user-friendly UI for managing Devise models.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run:

```bash
bundle exec rake install
```

To release a new version, update the version number in version.rb, and then run:

```bash
bundle exec rake release
```

This will create a git tag for the version, push git commits and the created tag, and push the .gem file to RubyGems.org.

## With Docker

``` bash
docker compose build
docker compose up -d
docker compose exec -it devise_rails bundle exec rails console
docker compose exec -it next_admin sh
docker compose attach devise_rails
docker compose logs next_admin -f
```

## Contributing

Bug reports and pull requests are welcome on GitHub at DeviseCrud GitHub Repository. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the code of conduct.

## License

The gem is available as open source under the terms of the MIT License.

## Code of Conduct

Everyone interacting in the DeviseCrud project's codebases, issue trackers, chat rooms, and mailing lists is expected to follow the code of conduct.
