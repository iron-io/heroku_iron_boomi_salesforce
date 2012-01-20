
post '/lead' do
  puts 'in lead'
  lead = Contact.new
  lead.name = params[:name]
  lead.email = params[:email]
  lead.company = params[:company]
  lead.save!
  puts "Saved lead: " + lead.inspect

  msg = {
      'id'=>lead.id.to_s,
      'name'=>lead.name,
      'email'=>lead.email,
      'company'=>lead.company
  }
  puts "Putting message on queue: " + msg.inspect

  resp = settings.ironmq.messages.post(msg.to_json, :queue_name=>'lead')
  p resp

  flash[:notice] = "Lead saved. Thank you!"

  redirect "/"
end

get '/leads' do
  @contacts = Contact.all
  erb :contacts
end

get '*' do
  erb :index
end
