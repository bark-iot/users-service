require 'sinatra'

set :bind, '0.0.0.0'
set :port, 80
set :public_folder, 'public'

get '/users' do
  'Hello world!'
end

get '/users/docs' do
  redirect '/users/docs/index.html'
end