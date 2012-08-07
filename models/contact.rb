class Contact
  include Jsonable
  include Idable

  attr_accessor :email, :name, :company, :salesforce_id, :status, :action, :result
end

