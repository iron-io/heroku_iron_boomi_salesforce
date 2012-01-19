require 'sinatra'
require 'iron_worker'
require 'iron_mq'
require 'mongoid'
require 'yaml'
require 'rack-flash'
require 'sinatra/base'

enable :sessions
use Rack::Flash

set :public_folder, File.dirname(__FILE__) + '/static'

def load_config(f)
  config = nil
  if File.exists?(f)
    config = YAML.load_file(f)
  end
  config
end

f = 'config.yml'
@config = load_config(f)
@config = load_config(File.expand_path(File.join("~", "Dropbox", "configs", "boomi", "config.yml"))) unless @config
@config = {} unless @config

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

ironmq = IronMQ::Client.new('token' => @config["iron"]["token"], 'project_id' => @config["iron"]["project_id"])
ironmq.logger.level = Logger::DEBUG
set :ironmq, ironmq

Mongoid.configure do |config|
  config.master = Mongo::Connection.from_uri(@config["mongo"]["uri"] + '/' + @config["mongo"]["database"])[@config["mongo"]["database"]]
end

require 'models/contact'

require 'controllers/main'
