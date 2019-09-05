require 'YAML'

class PodcastAgent
  attr_reader :app, :type

  def initialize(attrs)
    @app = attrs['name']
    @type  = attrs['type']
  end

  def self.parse(string)
    entry = database.find do |attrs|
      string =~ Regexp.new(attrs['regex'])
    end
    new(entry) if entry
  end

  def self.database
    @database ||= YAML.load_file('lib/user_agents.yml')
  end

end

