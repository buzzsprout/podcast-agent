require "yaml"
require "user_agent"

class PodcastAgentParser
  attr_reader :name,  :bot, :type, :browser, :platform, :device
  def initialize(name:, bot:, user_agent:)
    @name  = name
    @bot = (bot == true)
    @user_agent  = user_agent
    @browser     = user_agent.browser
    @platform    = user_agent.platform
    @device      = find_device
  end

  def to_s
    "#{name} - #{browser} - #{platform}"
  end

  def self.find_by(user_agent_string: nil, referrer: nil)
    entry = match("user_agent_match", user_agent_string)
    entry ||= match("referrer_match", referrer)
    entry ||= find_browser(user_agent_string)
    entry ||= {"name" => nil, "bot" => nil}

    new(name: entry["name"], bot: entry["bot"], user_agent: UserAgent.parse(user_agent_string))
  end

  def self.database
    @database ||= YAML.load_file(File.join(__dir__, "data/podcast_agents.yml"))
  end

  private

    def self.find_browser(user_agent_string)
      user_agent = UserAgent.parse(user_agent_string)
      if ["Edge", "Chrome", "Firefox", "Opera", "Explorer", "Internet Explorer", "Safari"].include? user_agent.browser
        return {"name" => "Web Browser", "bot" => false}
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
      when /HomePod/
        { name: "Apple HomePod", type: types[:smart_speaker] }
      when /ipad|iPad|IPAD/
        { name: "Apple iPad", type: types[:mobile] }
      when /Apple TV|AppleTV|apple;apple_tv/
        { name: "Apple TV", type: types[:smart_tv] }
      when /iphone|iOS|iPhone|CFNetwork\//
        { name: "Apple iPhone", type: types[:mobile] }
      when /watch|Watch OS/
        { name: "Apple Watch", type: types[:watch] }
      when /iPod|IPOD/
        { name: "Apple iPod", type: types[:mobile] }
      when /OS X|OSX|Macintosh|Macbook/
        { name: "Apple Computer", type: types[:computer] }
      end
    end

    def other_device_info
      case @user_agent.to_s
      when /GoogleChirp|Google-Speech-Actions/
        { name: "Google Home", type: types[:smart_speaker] }
      when /Chromebook|CrOS/
        { name: "Google Chromebook", type: types[:computer] }
      when /[a|A]ndroid.*[t|T]ablet|[t|T]ablet.*[a|A]ndroid|SM-T| GT-/
        { name: "Android Tablet", type: types[:mobile] }
      when /^(?=.*(ServeStream|Android|android|HTC|ExoPlayer))(?!.*CrKey).*/
        { name: "Android Phone", type: types[:mobile] }
      when /Windows|windows|WMPlayer|Winamp|Win32|Win64|NSPlayer|MediaMonkey|NSPlayer|PC/
        { name: "Windows Computer", type: types[:computer] }
      when /Alexa|^Echo\//
        { name: "Amazon Smart Speaker", type: types[:smart_speaker] }
      end
    end

    def unknown_device_info
      case @user_agent.to_s
      when /SmartTV|Roku|CrKey|AFTT Build|AFTM Build|BRAVIA 4K|Opera TV|SmartTv|TSBNetTV|SMART-TV|TV Safari|WebTV|InettvBrowser|GoogleTV|HbbTV|smart-tv|olleh tv/
        { name: "Unknown Smart TV", type: types[:smart_tv] }
      when /sonos|Sonos|^Bose\/|^VictorReader/
        { name: "Unknown Smart Speaker", type: types[:smart_speaker] }
      when /Lavf\/|desktop|Linux|linux|VLC|^okhttp\/|CastBox\//
        { name: "Unknown Computer", type: types[:computer] }
      when /tablet|Tablet/
        { name: "Unknown Tablet", type: types[:mobile] }
      when /watch|Watch/
        { name: "Unknown Watch", type: types[:watch] }
      when /^Player FM$|^Podkicker\/|spotify_unknown|^Castro|^Swoot Agent/
        { name: "Unknown Device", type: types[:mobile] }
      else
        { name: "Unknown Device", type: types[:unknown] }
      end
    end

    def types
      { mobile: "Mobile", computer: "Computer", smart_speaker: "Smart Speaker", smart_tv: "Smart TV", unknown: "Unknown", watch: "Watch" }
    end

end
