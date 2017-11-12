require 'securerandom'
require 'bcrypt'

class User < Sequel::Model(DB)
  class Update < Trailblazer::Operation
    extend Contract::DSL

    step :model!
    step Contract::Build()
    step :hash_password
    step Contract::Validate()
    step :set_timestamps
    step Contract::Persist()

    contract do
      property :token, virtual: true
      property :username
      property :password

      validation do
        required(:token).filled
      end
    end

    def model!(options, params:, **)
      options['model'] = User.where(token: params[:token]).first
      options['model']
    end

    def hash_password(options, params:, **)
      params[:password] = BCrypt::Password.create(params[:password]) if params[:password]
      true
    end

    def set_timestamps(options, model:, **)
      timestamp = Time.now
      model.updated_at = timestamp
    end
  end
end