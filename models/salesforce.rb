class Salesforce
  include Mongoid::Document

  field :email, type: String
  field :name, type: String
  field :salesforce_id, type: String
  field :action, type: String
  field :result, type: String
end
