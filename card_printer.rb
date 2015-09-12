$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'sinatra'
require 'yaml'
require 'lib/pivotal_to_pdf_settings.rb'

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
