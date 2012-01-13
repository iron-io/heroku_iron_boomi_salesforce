get '*' do
  erb :index
end

post '/lead' do
  puts 'in lead'
  lead = Contact.new
  lead.name = params[:name]
  lead.email = params[:email]
  lead.save!
  p lead
  redirect "/"
end
