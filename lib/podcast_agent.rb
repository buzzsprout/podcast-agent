require 'yaml'
require 'user_agent'

class PodcastAgent
  attr_reader :name, :type, :browser, :platform

  def initialize(name:, type:, user_agent:)
    @name  = name
    @type = type
    @user_agent = user_agent
    @browser    = user_agent.browser
    @platform   = user_agent.platform
  end

  def self.find_by(user_agent_string:)
    entry = database.find do |attrs|
      user_agent_string =~ Regexp.new(attrs['regex'])
    end
    new(name: entry['name'], type: entry['type'], user_agent: UserAgent.parse(user_agent_string)) if entry
  end

  def self.database
    @database ||= YAML.load_file('lib/data/podcast_agents.yml')
  end

end

