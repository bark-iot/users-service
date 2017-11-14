require 'securerandom'
require 'bcrypt'

class User < Sequel::Model(DB)
  class FindByEmailPassword < Trailblazer::Operation
    extend Contract::DSL

    step Contract::Build()
    step Contract::Validate()
    step :find_by_email_password
    step :log_success
    failure  :log_failure

    contract do
      property :email, virtual: true
      property :password, virtual: true

      validation do
        required(:email).filled
        required(:password).filled
      end
    end

    def find_by_email_password(options, params:, **)
      options['model'] = User.where(email: params[:email]).first
      if options['model']
        options['model'] = nil if BCrypt::Password.new(options['model'].password) != params[:password]
      end
      options['model']
    end

    def log_success(options, params:, model:, **)
      LOGGER.info "[#{self.class}] Found user with params #{params.to_json}. User: #{User::Representer.new(options['model']).to_json}"
    end

    def log_failure(options, params:, **)
      LOGGER.info "[#{self.class}] Failed to find user with params #{params.to_json}"
    end
  end
end