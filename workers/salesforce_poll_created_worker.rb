require 'iron_worker'

class SalesforcePollCreatedWorker < IronWorker::Base
  attr_accessor :iron_project_id
  attr_accessor :iron_token

  attr_accessor :mongodb_uri
  attr_accessor :mongodb_database

  merge_gem 'iron_mq'
  merge_gem 'mongoid'

  merge '../models/contact'

  def run
    mq = IronMQ::Client.new('token' => @iron_token, 'project_id' => @iron_project_id)
    mq.queue_name = 'lead_created'

    Mongoid.configure do |config|
      config.master = Mongo::Connection.from_uri(@mongodb_uri + '/' + @mongodb_database)[@mongodb_database]
    end

    while true
      msg = mq.messages.get
      if msg.nil?
        puts 'No more messages'
        break
      end

      p msg
      p msg.body
      if msg.body.nil? || msg.body == ""
        puts "Body is null, deleting."
        msg.delete
        next
      end

      body = JSON.parse(msg.body)

      puts "got salesforce_id #{body['salesforce_id']} for contact id #{body['id']}"

      begin
        c = Contact.find(body['id'])
      rescue => ex
        puts "Couldn't find contact! #{ex.message}"
        p msg.delete
        next
      end
      c.salesforce_id = body['salesforce_id']
      c.save!

      puts "set salesforce_id for contact id #{c.id} email #{c.email}"

      p msg.delete
    end
  end
end
