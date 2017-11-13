require 'securerandom'
require 'bcrypt'

class User < Sequel::Model(DB)
  class Create < Trailblazer::Operation
    extend Contract::DSL

    step Model(User, :new)
    step Contract::Build()
    step :hash_password
    step Contract::Validate()
    step :set_timestamps
    step :generate_token
    step Contract::Persist()

    contract do
      property :username
      property :email
      property :password

      validation do
        required(:email).filled
        required(:password).filled
        #TODO: password length validation, email format validation, unique email validation
      end
    end

    def hash_password(options, params:, **)
      params[:password] = BCrypt::Password.create(params[:password]) if params[:password]
      true
    end

    def set_timestamps(options, model:, **)
      timestamp = Time.now
      model.created_at = timestamp
      model.updated_at = timestamp
    end

    def generate_token(options, model:, **)
      model.token = SecureRandom.uuid
    end
  end
end