require 'sinatra'

settings = {
  :token => '',
  :formatter => 'PivotalToPdf::Formatters::LargeText'
}

get '/' do
  erb :index 
end

post '/' do
  @story_ids = params['story_ids']
  @project_id = params['project_id']

  f = File.open("/Users/scottspeidel/.pivotal.yml","w")
  f.write("token: #{settings[:token]}\n") 
  f.write("project_id: #{@project_id}\n") 
  f.write("formatter: #{settings[:formatter]}") 
  f.close

  `pivotal_to_pdf story #{@story_ids}`
  send_file 'stories.pdf'
end
