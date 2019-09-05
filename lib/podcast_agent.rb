require 'YAML'

class PodcastAgent
  attr_reader :app, :type

  def initialize(attrs)
    @app = attrs['name']
    @type  = attrs['type']
  end

  def self.find_by(user_agent_string:, referrer: nil)
    entry = database.find do |attrs|
      user_agent_string =~ Regexp.new(attrs['regex'])
    end
    new(entry) if entry
  end

  def self.database
    @database ||= YAML.load_file('lib/data/podcast_agents.yml')
  end

end

