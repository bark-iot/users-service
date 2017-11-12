require File.expand_path '../spec_helper.rb', __FILE__

describe 'Users Service' do
  before(:each) do
    DB.execute('TRUNCATE TABLE users;')
  end

  it 'should create user' do
    post '/users', {username: 'Bob', email: 'bob@test.com', password: '123456'}
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['email'] == 'bob@test.com').to be_truthy
    expect(body['token'] != '').to be_truthy
    expect(User.first.password != '').to be_truthy
  end

  it 'should not create user without required fields' do
    post '/users', {username: 'Bob'}
    expect(last_response.status).to equal(422)
    body = JSON.parse(last_response.body)
    expect(body[0] == ['email', ['must be filled']]).to be_truthy
    expect(body[1] == ['password', ['must be filled']]).to be_truthy
  end

  it 'should allow user to update his profile' do
    user = User::Create.(email: 'bob@test.com', password: '123456')['model']
    header 'Authorization', "Bearer #{user.token}"
    post '/users/update', username: 'Bob'
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['username'] == 'Bob').to be_truthy
  end

  it 'should not allow user to update profile without token' do
    post '/users/update', username: 'Bob'
    expect(last_response.status).to equal(401)
  end

  it 'should not allow user to update email' do
    user = User::Create.(email: 'bob@test.com', password: '123456')['model']
    header 'Authorization', "Bearer #{user.token}"
    post '/users/update', username: 'Bob', email: 'bob2@test.com'
    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['username'] == 'Bob').to be_truthy
    expect(body['email'] == 'bob@test.com').to be_truthy
  end

  it 'should return 404 if update called with wrong token' do
    header 'Authorization', 'Bearer wrong-token'
    post '/users/update', username: 'Bob'
    expect(last_response.status).to equal(404)
  end

  it 'should find user by token' do
    user = User::Create.(email: 'bob@test.com', password: '123456')['model']
    header 'Authorization', "Bearer #{user.token}"
    get '/users/by_token'

    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['email'] == 'bob@test.com').to be_truthy
  end

  it 'should return 404 if user not found by token' do
    header 'Authorization', 'Bearer some-test-token'
    get '/users/by_token'
    expect(last_response.status).to equal(404)
  end
end