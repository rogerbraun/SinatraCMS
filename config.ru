require "rubygems"
require "bundler"

Bundler.require

require "./boot.rb"

run Sinatra::Application
