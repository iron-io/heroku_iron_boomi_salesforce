require 'uuid'

module Idable

  def id
    @id
  end

  def id=(id)
    @id = id
  end

  def self.generate_id
    UUID.new.generate
  end

end
