require 'iron_worker'
require 'time'
require_relative '../config'
require_relative 'lead_worker'

IronWorker.logger.level = Logger::DEBUG

IronWorker.configure do |iwc|
  iwc.token = @config["iron"]["token"]
  iwc.project_id = @config["iron"]["project_id"]
end

worker = LeadWorker.new
worker.iron_project_id = @config['iron']['project_id']
worker.iron_token = @config['iron']['token']
worker.mongodb_uri = @config['mongo']['uri']
worker.mongodb_database = @config['mongo']['database']

worker.run_local
#worker.queue
#worker.upload
#worker.schedule(:start_at=>Time.now.iso8601, :run_every=>600)
