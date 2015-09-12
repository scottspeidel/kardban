require 'yaml'
require 'singleton'
class Config
  include Singleton

  attr_accessor :settings
  
  def initialize
    @settings = {}
  end

  def add(key, value)
    @settings[key] = value
  end

  def parse_yml(file)
    @settings = YAML.load_file(file)
  end
end
