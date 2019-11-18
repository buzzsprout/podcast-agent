require 'yaml'
require 'user_agent'

class PodcastAgent
  attr_reader :name,  :bot, :type, :browser, :platform, :device, :device_type
  def initialize(name:, bot:, user_agent:)
    @name  = name
    @bot = bot
    @user_agent  = user_agent
    @browser     = user_agent.browser
    @platform    = user_agent.platform
    @device      = @bot ? "bot" : device_name(user_agent.to_s)
    @device_type = @bot ? "bot" : device_type_name(user_agent.to_s)
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

    def device_name(user_agent_string)
      case user_agent_string
      when /^Castro|^RSSRadio\/|ipad|iphone|iOS|iPad|^Podkicker\/|iPhone|iPod|watchOS|iTunes|HomePod|CFNetwork|iTMS|AppleNews|^Podcasts\/|AppleWebKit|OSX/
        "Apple Phone/Tablet/Watch/iPod/HomePod"
      when /ServeStream|Android|android|HTC|ExoPlayer|AntennaPod|^Podkicker Pro/
        "Android Phone/Tablet/Watch"
      when /OS X/
        "Mac Computer"
      when /Windows|WMPlayer|Winamp|Win32|Win64|NSPlayer|MediaMonkey/
        "Windows Computer"
      when /Chromebook/
        "Chrome Computer"
      when /Amazon|Alexa|^Echo\//
        "Amazon Fire/Echo/Alexa"
      when /GoogleChirp/
        "Google Home/Nest"
      when /SmartTV|Apple TV|Roku/
        "Smart TV"
      else
        # puts "not identified #{user_agent_string}"
        "Unknown"
      end
    end

    def device_type_name(user_agent_string)    
      case user_agent_string
      when /iCatcher!|[w|W]atch|^Subcast\/|^bPod$|^TREBLE\/|^OkDownload|^RSSRadio|ipad|iphone|iOS|iPad|iPhone|iPod|[A|a]ndroid|HTC|WhatsApp|Ubook Player|CFNetwork|[m|M]obile|^Zune|VictorReader|^Swoot|^ServeStream|^Podkicker|^Podcoin|^Pocket Casts|^Castro|^Bullhorn|^AntennaPod|^doubleTwist CloudPlayer|^okhttp|ExoPlayer|^Player FM$|^CastBox\//
        "Phone/Tablet/MP3 Player/Watch"
      when /^GStreamer|MusicBee|^iTunes\/|^Headliner\/|^VLC|^gPodder|^Opera\/|Macbook|OSX|OS X|Win32|Win64|Windows|windows|WMPlayer|Linux|linux|NSPlayer|^MediaMonkey|Clementine|^BashPodder|^Mozilla\/5.0|desktop|Desktop|PC|laptop|^Lavf\//
        "Desktop/Laptop"
      when /Alexa|Amazon|^Echo|HomePod|Sonos|GoogleChirp|^Bose\//
        "Smart Speaker"
      when /Apple TV|SmartTV|Roku|CrKey|AFTT Build||AFTM Build|BRAVIA 4K|Opera TV|SmartTv|TSBNetTV|SMART-TV|TV Safari|WebTV|InettvBrowser|GoogleTV|HbbTV|smart-tv|olleh tv/
        "Smart TV"
      else
        # puts "not identified #{user_agent_string}"
        "Unknown"
      end
    end



end
