require 'yaml'
require 'user_agent'

class PodcastAgent
  attr_reader :name, :type, :browser, :platform

  def initialize(name:, bot:, user_agent:)
    @name  = name
    @bot = bot
    @user_agent = user_agent
    @browser    = user_agent.browser
    @platform   = user_agent.platform
  end

  def to_s
    "#{name} - #{browser} - #{platform}"
  end

  def self.find_by(user_agent_string:)
    entry = database.find do |attrs|
      user_agent_string =~ Regexp.new(attrs['user_agent_match'])
    end
    new(name: entry['name'], bot: entry['bot'], user_agent: UserAgent.parse(user_agent_string)) if entry
  end

  def self.database
    @database ||= YAML.load_file('lib/data/podcast_agents.yml')
  end

end

