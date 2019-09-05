require 'test_helper'

class PocastUserAgentTest < ActiveSupport::TestCase

  test 'should match all examples' do
    user_agent_samples.each do |app, samples|
      samples.each do |sample|
        ua = PodcastUserAgent.parse(sample)
        assert ua, "'#{sample}' could not be parsed as #{app}'"
        assert_equal app, ua.app, sample
      end
    end
  end

end