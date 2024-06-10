source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.3.2"

gem "bcrypt", "~> 3.1.7"
gem "bootsnap", require: false
gem "csv"
gem "importmap-rails"
gem "jbuilder"
gem "litestack", github: "oldmoe/litestack"
gem "puma", ">= 5.0"
gem "rails", "~> 7.1.3", ">= 7.1.3.4"
gem "sprockets-rails"
gem "sqlite3", "~> 1.4"
gem "stimulus-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[windows jruby]
gem "view_component"

group :development, :test do
  gem "debug", platforms: %i[mri windows]
  gem "standard"
end

group :development do
  gem "annotate"
  gem "chusaku", require: false
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "simplecov", require: false
end

gem "dockerfile-rails", ">= 1.6", :group => :development
