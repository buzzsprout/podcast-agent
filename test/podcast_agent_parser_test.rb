require_relative "test_helper"

class PocastAgentParserTest < ActiveSupport::TestCase

  test "should match all sample user_agents" do
    agent_samples.each do |name, samples|
      samples.each do |sample|
        if samples["user_agents"]
          samples["user_agents"].each do |user_agent_string|
            agent = PodcastAgentParser.find_by(user_agent_string: user_agent_string)
            assert agent, "User Agent '#{user_agent_string}' could not be parsed as #{name}'"
            assert_equal name, agent.name, sample
          end
        end
      end
    end
  end

  test "should match the app and the browser" do
    pandora_user_agent = "Mozilla/5.0 (iPad; CPU OS 12_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Pandora/1908.1"
    agent = PodcastAgentParser.find_by(user_agent_string: pandora_user_agent)
    assert_equal "Pandora", agent.name
    assert_equal "Safari", agent.browser
    assert_equal "iPad", agent.platform
  end

  test "should match all sample referrers" do
    agent_samples.each do |name, samples|
      samples.each do |sample|
        if samples["referrers"]
          samples["referrers"].each do |referrer|
            agent = PodcastAgentParser.find_by(referrer: referrer)
            assert agent, "Referrer '#{referrer}' could not be parsed as #{name}'"
            assert_equal name, agent.name, sample
          end
        end
      end
    end
  end

  test "should prefer the user agent match over the referrer" do
    google_bot_user_agent = "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)"
    stitcher_referrer = "https://app.stitcher.com/"
    agent = PodcastAgentParser.find_by(user_agent_string: google_bot_user_agent,
                                       referrer: stitcher_referrer)
    assert_equal "Google Bot", agent.name
  end

  test "devices match" do
    devices.each do |user_agent, device_data|
      agent = PodcastAgentParser.find_by(user_agent_string: user_agent)
      if device_data[0] == "nil"
        refute agent.name, "#{user_agent} - #{agent.name} should be nil"
      else
        assert_equal device_data[0], agent.name, "#{user_agent} app does not match"
      end
      assert_equal device_data[1], agent.device.name, "#{user_agent} device does not match"
      assert_equal device_data[2], agent.device.type, "#{user_agent} device type does not match"
    end
  end

  private

  def agent_samples
    @agent_samples ||= YAML.load_file(File.join(__dir__, "data/samples.yml"))
  end

  def devices
    @devices ||= YAML.load_file(File.join(__dir__, "data/devices.yml"))
  end

end
