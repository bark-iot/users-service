require 'roar/decorator'
require 'roar/json'

class User < Sequel::Model(DB)
  class Representer < Roar::Decorator
      include Roar::JSON

      property :id
      property :username
      property :email
      property :token
      property :created_at
      property :updated_at
  end
end