# frozen_string_literal: true

source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }
ruby File.read(".ruby-version").strip

gem "acts_as_tree"
gem "addressable"
gem "audited", "~> 5.4"
gem "aws-sdk-s3", "~> 1.177"
gem "bigdecimal"
gem "bootsnap", ">= 1.1.0", require: false
gem "cssbundling-rails", "~> 1.4"
gem "csv-safe"
gem "govuk_design_system_formbuilder", "~> 4.1.1"
gem "haml-rails"
gem "high_voltage"
gem "ipaddr"
gem "jbuilder", "~> 2.13"
gem "jsbundling-rails", "~> 1.3"
gem "pg"
gem "mail-notify"
gem "monetize"
gem "mutex_m"
gem "nanoid"
gem "notifications-ruby-client"
gem "parser"
gem "pry-rails"
gem "puma", "~> 6.5"
gem "pundit"
gem "rollbar"
gem "rails", "~> 7.0"
gem "rack-attack"
gem "rollout"
gem "rollout-ui"
gem "redis", "~> 5"
gem "redis-namespace"
gem "redis-actionpack"
gem "redis-store"
gem "sidekiq", "~> 7"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "wicked"
gem "strip_attributes"
gem "breadcrumbs_on_rails"
gem "sprockets-rails"

# Authentication
gem "devise"
gem "devise-two-factor"
gem "devise-security"

group :development, :test do
  gem "brakeman"
  gem "bullet"
  gem "byebug", platforms: %i[mri mingw x64_mingw]
  gem "pry-byebug"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "faker"
  gem "foreman"
  gem "i18n-tasks", "~> 1.0.14"
  gem "rspec-rails"
  gem "standard"
end

group :development do
  gem "binding_of_caller"
  gem "better_errors"
  gem "html2haml"
  gem "listen", ">= 3.0.5", "< 3.10"
  gem "rails_layout"
  gem "web-console", ">= 3.3.0"
end

group :test do
  gem "capybara", ">= 2.15"
  gem "climate_control"
  gem "simplecov", "~> 0.22.0", require: false
  gem "simplecov-lcov", "~> 0.8.0", require: false
  gem "database_cleaner"
  gem "fakeredis", require: false
  gem "launchy"
  gem "pundit-matchers", "~> 4.0.0"
  gem "rails-controller-testing"
  gem "shoulda-matchers"
  gem "selenium-webdriver"
  gem "webmock", "~> 3.24"
end

group :production do
  gem "lograge"
end
