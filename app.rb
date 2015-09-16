$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'yaml'
require 'omniauth-github'
require 'omniauth-openid'
require 'openid/store/filesystem'
require 'lib/pivotal_to_pdf_settings.rb'

use Rack::Session::Cookie 
use OmniAuth::Builder do
  provider :github, ENV['GITHUB_KEY'], ENV['GITHUB_SECRET']
  provider :openid, :store => OpenID::Store::Filesystem.new("#{Dir.pwd}/tmp")
end

%w(get post).each do |method|
  send(method, "/auth/:provider/callback") do
    env['omniauth.auth'] # => OmniAuth::AuthHash
    redirect '/'
  end
end

get '/auth/failure' do
  #flash[:notice] = params[:message] # if using sinatra-flash or rack-flash
  redirect '/'
end

get '/' do
  erb :index 
end

post '/' do
  story_ids = params['story_ids']
  project_id = params['project_id']
  store_pivotal_to_pdf_settings(project_id)
  `pivotal_to_pdf story #{story_ids}`
  send_file 'stories.pdf'
end
