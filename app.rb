$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'yaml'
require 'omniauth-github'
require 'omniauth-openid'
require 'openid/store/filesystem'
require 'lib/pivotal_to_pdf_settings.rb'

class Kardban < Sinatra::Application
  enable :sessions

  use Rack::Session::Cookie
  use OmniAuth::Builder do
    provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
    provider :openid, :store => OpenID::Store::Filesystem.new("#{Dir.pwd}/tmp")
  end

  %w(get post).each do |method|
    send(method, "/auth/:provider/callback") do
      session[:uid] = env['omniauth.auth']['uid']
      session[:user_name] = env['omniauth.auth']['info']['name']
      redirect '/'
    end
  end

  get '/auth/failure' do
    #flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
    redirect '/'
  end

  get '/' do
    redirect '/login' if session[:uid].nil?

    @user_name = session[:user_name]
    erb :index
  end

  get '/login' do
    erb :login
  end

  get '/logout' do
    session[:uid] = nil
    session[:user_name] = nil
    
    erb :login
  end

  post '/' do
    story_ids = params['story_ids']
    project_id = params['project_id']
    store_pivotal_to_pdf_settings(project_id)
    `pivotal_to_pdf story #{story_ids}`
    send_file 'stories.pdf'
  end
end

