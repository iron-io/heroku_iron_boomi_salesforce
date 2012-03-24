require 'iron_worker'

class ConvertedWorker < IronWorker::Base
  attr_accessor :iron_project_id
  attr_accessor :iron_token

  attr_accessor :mongodb_uri
  attr_accessor :mongodb_database

  merge_gem 'iron_mq'
  merge_gem 'mongoid'

  merge '../models/contact'

  def run
    mq = IronMQ::Client.new('token' => @iron_token, 'project_id' => @iron_project_id)
    mq.queue_name = 'converted'

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

      salesforce_id = body['salesforce_id']
      puts "got salesforce_id #{salesforce_id}"

      c = nil
      begin
        c = Contact.where(salesforce_id: salesforce_id).first
      rescue => ex
        puts "Error finding contact! #{ex.message}"
      end
      if c.nil?
        puts "Couldn't find contact! #{salesforce_id}"
        # p msg.delete
        next
      end
      c.action = body['action']
      c.status = body['to'] # opportunity
      c.save!

      puts "set salesforce_id for contact id #{c.id} email #{c.email}"

      #p msg.delete
    end
  end
end
