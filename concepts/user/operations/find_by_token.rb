require 'securerandom'
require 'bcrypt'

class User < Sequel::Model(DB)
  class FindByToken < Trailblazer::Operation
    extend Contract::DSL

    step Contract::Build()
    step Contract::Validate()
    step :find_by_token
    step :log_success
    failure  :log_failure

    contract do
      property :token, virtual: true

      validation do
        required(:token).filled
      end
    end

    def find_by_token(options, params:, **)
      options['model'] = User.where(token: params[:token]).first
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