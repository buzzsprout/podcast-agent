require 'test_helper'

class PocastAgentTest < ActiveSupport::TestCase

  test 'should match all sample user_agents' do
    user_agent_samples.each do |name, samples|
      samples.each do |sample|
        if samples['user_agents']
          samples['user_agents'].each do |user_agent_string|
            agent = PodcastAgent.find_by(user_agent_string: user_agent_string)
            assert agent, "'#{sample}' could not be parsed as #{name}'"
            assert_equal name, agent.name, sample
          end
        end
      end
    end
  end

  test 'should match the app and the browser' do
    pandora_user_agent = 'Mozilla/5.0 (iPad; CPU OS 12_3 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148 Pandora/1908.1'
    agent = PodcastAgent.find_by(user_agent_string: pandora_user_agent)
    assert_equal 'Pandora', agent.name
    assert_equal 'Safari', agent.browser
    assert_equal 'iPad', agent.platform
  end

end