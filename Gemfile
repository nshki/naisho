source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "csv"
gem "dockerfile-rails", ">= 1.6", group: :development
gem "importmap-rails"
gem "jbuilder"
gem "propshaft"
gem "puma", "~> 6.0"
gem "rails", "~> 8.0.0"
gem "solid_cable"
gem "solid_cache"
gem "solid_queue"
gem "sqlite3"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "view_component"

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "standard"
end

group :development do
  gem "annotaterb"
  gem "chusaku", require: false
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "mocktail"
  gem "selenium-webdriver"
  gem "simplecov", require: false
end
