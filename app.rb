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

$: << '.'
require 'config'

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
