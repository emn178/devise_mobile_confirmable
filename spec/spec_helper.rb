require 'simplecov'
require 'coveralls'

SimpleCov.add_filter 'version'
SimpleCov.add_filter 'templates'

if ENV["COVERAGE"]
  SimpleCov.start 'rails'
elsif ENV["COVERALLS"]
  SimpleCov.formatter = Coveralls::SimpleCov::Formatter
  Coveralls.wear!
end


# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
# Prevent database truncation if the environment is production
abort("The Rails environment is running in production mode!") if Rails.env.production?
require 'rspec/rails'


$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)
require 'devise_mobile_confirmable'
require 'rspec/its'
require 'rails/generators'
require "generator_spec"

Dir[File.dirname(__FILE__) + "/support/**/*.rb"].each do |file|
  require file
end
