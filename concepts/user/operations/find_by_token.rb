require 'securerandom'
require 'bcrypt'

class User < Sequel::Model(DB)
  class FindByToken < Trailblazer::Operation
    extend Contract::DSL

    step Contract::Build()
    step Contract::Validate()
    step :find_by_token

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
  end
end