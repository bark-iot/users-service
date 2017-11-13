require 'securerandom'
require 'bcrypt'

class User < Sequel::Model(DB)
  class FindByEmailPassword < Trailblazer::Operation
    extend Contract::DSL

    step Contract::Build()
    step Contract::Validate()
    step :find_by_email_password

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
  end
end