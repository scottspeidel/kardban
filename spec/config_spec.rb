require 'config'
require 'tempfile'

describe 'Config' do

  it 'should read from a yaml file' do
    f = Tempfile.new('tmp')
    f.write "token : hgiq82hg02h03sadj8\n"
    f.write "vendor : pivotal"
    f.close
    Config.instance.parse_yml(f.path)
    expect(Config.instance.settings['token']).to eq "hgiq82hg02h03sadj8"
    expect(Config.instance.settings['vendor']).to eq "pivotal"
    f.unlink
  end

end
