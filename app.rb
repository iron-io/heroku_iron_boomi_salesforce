require 'rubygems'
require 'sinatra'
require 'iron_worker'
require 'iron_mq'
require 'mongoid'

enable :sessions

set :public_folder, File.dirname(__FILE__) + '/static'

IronWorker.configure do |iwc|
  iwc.token = ENV['IRON_WORKER_TOKEN']
  iwc.project_id = ENV['IRON_WORKER_PROJECT_ID']
end

set :ironmq, IronMQ::Client.new('token' => ENV['IRON_WORKER_TOKEN'], 'project_id' => ENV['IRON_WORKER_PROJECT_ID'])

Mongoid.configure do |config|
  config.master = Mongo::Connection.from_uri(ENV['MONGODB_CONNECTION'] + '/' + ENV['MONGODB_DATABASE'])[ENV['MONGODB_DATABASE']]
end

require 'models/salesforce'

require 'controllers/main'
