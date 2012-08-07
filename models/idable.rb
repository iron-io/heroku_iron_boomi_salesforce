require 'uuid'

module Idable

  def self.generate_id
    UUID.new.generate
  end

end
