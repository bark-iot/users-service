require 'sinatra'
require './config/database.rb'
require './config/concepts.rb'
require './config/logging.rb'


set :bind, '0.0.0.0'
set :port, 80
set :public_folder, 'public'

post '/users' do
  result = User::Create.(params)
  if result.success?
    body User::Representer.new(result['model']).to_json
  else
    status 422
    body result['contract.default'].errors.messages.uniq.to_json
  end
end

post '/users/update' do
  token = bearer_token
  if token
    result = User::Update.(params.merge({token: token}))
    if result.success?
      body User::Representer.new(result['model']).to_json
    else
      if result['contract.default']
        status 422
        body result['contract.default'].errors.messages.uniq.to_json
      else
        status 404
      end
    end
  else
    status 401
  end
end

get '/users/by_token' do
  result = User::FindByToken.(token: bearer_token)
  if result.success?
    body User::Representer.new(result['model']).to_json
  else
    if result['contract.default'].errors.messages.size > 0
      status 422
      body result['contract.default'].errors.messages.uniq.to_json
    else
      status 404
    end
  end
end

post '/users/by_email_password' do
  result = User::FindByEmailPassword.(params)
  if result.success?
    body User::Representer.new(result['model']).to_json
  else
    status 404
  end
end

get '/users/docs' do
  redirect '/users/docs/index.html'
end

def bearer_token
  pattern = /^Bearer /
  header = request.env['HTTP_AUTHORIZATION']
  header.gsub(pattern, '') if header && header.match(pattern)
end