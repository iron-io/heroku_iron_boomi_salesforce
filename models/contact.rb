class Contact
  include Mongoid::Document
  include Mongoid::Timestamps

  field :email, type: String
  field :name, type: String
  field :company, type: String
  field :salesforce_id, type: String
  field :status, type: String
  field :action, type: String
  field :result, type: String
end
