require 'spec_helper'

describe 'app' do
  include Rack::Test::Methods

  def app
    Kardban
  end

  describe 'omniauth' do

    it 'should set the uid and user_name in session' do
      OmniAuth.config.add_mock(:github,
                               { provider: 'github',
                                 uid: '1234567',
                                 info: { name: 'Josefina' }
                               })

      get '/auth/github/callback'
      expect(last_request.env['rack.session']['uid']).to eql '1234567'
      expect(last_request.env['rack.session']['user_name']).to eql 'Josefina'
    end
  end

  describe 'login' do
    it 'should redirect to login if user is not logged in' do
      get '/'
      expect(last_response).to be_redirect
      follow_redirect!
      expect(last_request.url).to include '/login'
      expect(last_response.body).to include 'Sign in with'
    end

    it 'should load form when user is logged in' do
      get '/', {}, 'rack.session' => { uid: '1234', user_name: 'Joe the Plumber' }
      expect(last_response).to be_ok
      expect(last_response.body).to include 'Logged in as Joe the Plumber'
    end

    it 'should have a login route' do
      get '/login'
      expect(last_response).to be_ok
      expect(last_response.body).to include 'Sign in with'
    end
  end
end
