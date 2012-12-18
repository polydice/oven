ENV['RACK_ENV'] ||= 'development'

require "rubygems"
require "bundler/setup"
require "./app.rb"

use Rack::Static, :urls => ["/css", "/img", "/js"], :root => "public"

run Oven::App

