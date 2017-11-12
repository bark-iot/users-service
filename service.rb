require 'sinatra'
require './config/database.rb'
require './config/concepts.rb'
require './config/debug.rb'


set :bind, '0.0.0.0'
set :port, 80
set :public_folder, 'public'

get '/users/me' do
  result = User::FindByToken.(token: bearer_token)
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