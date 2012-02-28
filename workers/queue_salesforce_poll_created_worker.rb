$: << '.'

require '../config'

require 'salesforce_poll_created_worker'

IronWorker.logger.level = Logger::DEBUG

IronWorker.configure do |iwc|
  iwc.token = @config["iron"]["token"]
  iwc.project_id = @config["iron"]["project_id"]
end

worker = SalesforcePollCreatedWorker.new
worker.iron_project_id = @config['iron']['project_id']
worker.iron_token = @config['iron']['token']
worker.mongodb_uri = @config['mongo']['uri']
worker.mongodb_database = @config['mongo']['database']

worker.run_local
#worker.queue
