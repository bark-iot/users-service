require 'securerandom'
require 'bcrypt'

class User < Sequel::Model(DB)
  class Create < Trailblazer::Operation
    extend Contract::DSL

    step Model(User, :new)
    step Contract::Build()
    step Contract::Validate()
    step :hash_password
    step :set_timestamps
    step :generate_token
    step Contract::Persist()

    contract do
      property :username
      property :email
      property :password

      validation do
        configure do
          config.messages_file = 'config/error_messages.yml'

          def email?(value)
            ! /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match(value).nil?
          end

          def unique_email?(value)
            User.where(email: value).first.nil?
          end
        end

        required(:email).filled
        rule(email: [:email]) do |email|
          email.filled?.then(email.email?)
        end
        rule(email: [:email]) do |email|
          email.filled?.then(email.unique_email?)
        end
        required(:password).filled
        rule(password: [:password]) do |password|
          password.filled?.then(password.min_size?(8))
        end
      end
    end

    def hash_password(options, params:, **)
      options['contract.default'].password = BCrypt::Password.create(params[:password]) if params[:password]
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