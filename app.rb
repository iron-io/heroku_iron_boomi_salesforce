require 'sinatra'
require 'iron_worker'
require 'iron_mq'
require 'yaml'
require 'uuid'
require 'rack-flash'
require 'sinatra/base'

# bump.

enable :sessions
use Rack::Flash

set :public_folder, File.expand_path(File.dirname(__FILE__) + '/assets')

$: << '.'
require 'config'

ironmq = IronMQ::Client.new()
ironmq.logger.level = Logger::DEBUG
set :ironmq, ironmq

require_relative 'models/idable'
require_relative 'models/contact'

require_relative 'controllers/main'

