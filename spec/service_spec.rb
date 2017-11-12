require File.expand_path '../spec_helper.rb', __FILE__

describe 'Users Service' do
  before(:each) do
    DB.execute('TRUNCATE TABLE users;')
  end

  it 'should create user' do
    #get '/users'
    #expect(last_response).to be_ok
  end

  it 'should not create invalid user' do
    #get '/users'
    #expect(last_response).to be_ok
  end

  it 'should allow user to edit his profile' do
    #get '/users'
    #expect(last_response).to be_ok
  end

  it 'should not allow user to edit profile without token' do
    #get '/users'
    #expect(last_response).to be_ok
  end

  it 'should find user by token' do
    user = User::Create.(email: 'bob@test.com', password: '123456')['model']
    header 'Authorization', "Bearer #{user.token}"
    get '/users/me'

    expect(last_response).to be_ok
    body = JSON.parse(last_response.body)
    expect(body['email'] != '').to be_truthy
  end

  it 'should return 404 if user not found by token' do
    header 'Authorization', 'Bearer some-test-token'
    get '/users/me'
    expect(last_response.status).to equal(404)
  end
end