# frozen_string_literal: true

source 'https://rubygems.org'

# Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem 'rails', '~> 8.1.4'
# Use sqlite3 as the database for Active Record
gem 'pg'
# Use the Puma web server [https://github.com/puma/puma]
gem 'puma', '>= 5.0'

# Manually added gems
gem 'dotenv-rails', groups: %i[development test]
gem 'rspec-rails'
gem 'rubocop', '~> 1.91', group: :development
gem 'rubocop-rails', group: :development

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[windows jruby]

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin Ajax possible
# gem "rack-cors"

group :development, :test do
  # See https://guides.rubyonrails.org/debugging_rails_applications.html#debugging-with-the-debug-gem
  gem 'debug', platforms: %i[mri windows], require: 'debug/prelude'
end
