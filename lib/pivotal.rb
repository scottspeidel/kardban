require 'httparty'
require 'uri'

class Pivotal
  include HTTParty
  base_uri 'https://www.pivotaltracker.com'
  
  def self.projects()
    uri = URI.parse("/services/v5/projects/")
    projects = []
    self.get( uri, headers: {"X-TrackerToken" => ENV['PIVOTALTOKEN'] }).each do |project|
      projects << {'name' => project['name'], 'id' => project['id']} 
    end 
    projects
  end

end
