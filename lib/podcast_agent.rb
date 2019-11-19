require 'yaml'
require 'user_agent'

class PodcastAgent
  attr_reader :name,  :bot, :type, :browser, :platform, :device
  def initialize(name:, bot:, user_agent:)
    @name  = name
    @bot = bot
    @user_agent  = user_agent
    @browser     = user_agent.browser
    @platform    = user_agent.platform
    @device      = find_device
  end

  def to_s
    "#{name} - #{browser} - #{platform}"
  end

  def self.find_by(user_agent_string: nil, referrer: nil)
    entry = match('user_agent_match', user_agent_string)
    entry ||= match('referrer_match', referrer)
    entry ||= find_browser(user_agent_string)

    new(name: entry['name'], bot: entry['bot'], user_agent: UserAgent.parse(user_agent_string)) if entry
  end

  def self.database
    @database ||= YAML.load_file('lib/data/podcast_agents.yml')
  end

  private

    def self.find_browser(user_agent_string)
      user_agent = UserAgent.parse(user_agent_string)
      if ["Edge", "Chrome", "Firefox", "Opera", "Explorer", "Internet Explorer", "Safari"].include? user_agent.browser
        return {name: user_agent.browser, bot: false}
      end
    end

    def self.match(attr, string)
      if string
        database.find do |attrs|
          string =~ Regexp.new(attrs[attr]) if attrs[attr]
        end
      end
    end

    def find_device
      @device_info = {name: "Bot", type: "Bot"} if @bot
      @device_info ||= apple_device_info
      @device_info ||= other_device_info
      @device_info ||= unknown_device_info

      return OpenStruct.new(@device_info)
    end

    def apple_device_info
      case @user_agent.to_s
      when /ipad|iPad|IPAD/
        {name: "Apple iPad", type: "Tablet"}
      when /Apple TV|AppleTV/
        {name: "Apple TV", type: "Smart TV"}
      when /iphone|iOS|iPhone|CFNetwork\// #CFnetwork is a device?
        {name: "Apple iPhone", type: "Phone"}
      when /watch|Watch OS/
        {name: "Apple Watch", type: "Watch"}
      when /iPod|IPOD/
        {name: "Apple Device", type: "Unknown"}
      when /OS X|OSX|Macintosh|Macbook/
        {name: "Mac Desktop", type: "Desktop/Laptop"}
      end
    end

    def other_device_info
      case @user_agent.to_s
      when /GoogleChirp|Google-Speech-Actions/
        {name: "Google Home", type: "Smart Speaker"}
      when /[a|A]ndroid.*[t|T]ablet|[t|T]ablet.*[a|A]ndroid|SM-T| GT-/
        {name: "Android Tablet", type: "Tablet"}
      when /^(?=.*(ServeStream|Android|android|HTC|ExoPlayer))(?!.*CrKey).*/
        {name: "Android Phone", type: "Phone"}
      when /Windows|windows|WMPlayer|Winamp|Win32|Win64|NSPlayer|MediaMonkey|NSPlayer|PC/
        {name: "Windows Desktop", type: "Desktop/Laptop"}
      when /Chromebook|CrOS/
        {name: "Chrome Computer", type: "Desktop/Laptop"}
      when /Amazon|Alexa|^Echo\//
        {name: "Amazon Fire/Echo/Alexa", type: "Smart Speaker"} #need to check for other fire agents? IS this confusing with fire TV?
      end
    end

    def unknown_device_info
      case @user_agent.to_s
      when /SmartTV|Roku|CrKey|AFTT Build|AFTM Build|BRAVIA 4K|Opera TV|SmartTv|TSBNetTV|SMART-TV|TV Safari|WebTV|InettvBrowser|GoogleTV|HbbTV|smart-tv|olleh tv/
        {name: "Unknown Smart TV", type: "Smart TV"}
      when /sonos|Sonos|^Bose\/|^VictorReader/
        {name: "Unknown Smart Speaker", type: "Smart Speaker"}
      when /Lavf\/|desktop|Linux|linux|VLC/
        {name: "Unknown Desktop", type: "Desktop/Laptop"}
      when /tablet|Tablet/
        {name: "Unknown Tablet", type: "Tablet"}
      when /watch|Watch/
        {name: "Unknown Watch", type: "Watch"}
      else
        {name: "Unknown Unknown", type: "Unknown"}
      end
    end

end
