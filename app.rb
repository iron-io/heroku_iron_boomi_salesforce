require 'sinatra'
require 'iron_worker'
require 'iron_mq'
require 'mongoid'
require 'yaml'
require 'rack-flash'
require 'sinatra/base'

# bump.

enable :sessions
use Rack::Flash

set :public_folder, File.dirname(__FILE__) + '/static'

@config = {}
@config = YAML.load_file('config.yml') if File.exists?('config.yml')

@config["iron"] ||= {}
@config["iron"]["token"] ||= ENV['IRON_WORKER_TOKEN']
@config["iron"]["project_id"] ||= ENV['IRON_WORKER_PROJECT_ID']

@config["mongo"] ||= {}
@config["mongo"]["uri"] ||= ENV['MONGODB_CONNECTION']
@config["mongo"]["database"] ||= ENV['MONGODB_DATABASE']

IronWorker.configure do |iwc|
  iwc.token = @config["iron"]["token"]
  iwc.project_id = @config["iron"]["project_id"]
end

ironmq =  IronMQ::Client.new('token' => @config["iron"]["token"], 'project_id' => @config["iron"]["project_id"])
ironmq.logger.level = Logger::DEBUG
set :ironmq, ironmq

Mongoid.configure do |config|
  config.master = Mongo::Connection.from_uri(@config["mongo"]["uri"] + '/' + @config["mongo"]["database"])[@config["mongo"]["database"]]
end

require 'models/contact'

require 'controllers/main'
