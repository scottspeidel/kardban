require 'spec_helper'
require 'pivotal'

describe 'Pivotal', :vcr => true do

  it 'should get a list of projects and store them in and array' do
    projects = Pivotal.projects()
    expect(projects).to include({"name"=>"Los Dorados", "id"=>781455})
    expect(projects).to include({"name"=>"Pumpkin Sharks", "id"=>1409872})
  end 

end
