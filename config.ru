require 'rubygems'
require 'bundler'
Bundler.require

$: << File.expand_path(File.dirname(__FILE__))

require 'app'

run Sinatra::Application
