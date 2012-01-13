require 'mongoid'

class SalesforcePollCreatedWorker << IronWorker::Base
  attr_accessor :iron_project_id
  attr_accessor :iron_token

  attr_accessor :mongodb_connection
  attr_accessor :mongodb_database

  merge_gem 'iron_mq'

  merge '../models/salesforce'

  def run
    mq = IronMQ::Client.new('token' => @iron_token, 'project_id' => @iron_project_id)
    mq.queue_name = 'lead_created'

    Mongoid.configure do |config|
      config.master = Mongo::Connection.from_uri(@mongodb_connection + '/' + @mongodb_database)[@mongodb_database]
    end

    while true
      msg = mq.messages.get
      break if msg.nil?

      msg = JSON.parse(msg)

      sf = Salesforce.find(msg['id'])
      sf.salesforce_id = msg['salesforce_id']
      sf.save

      msg.delete
    end
  end
end
