require 'test_helper'

class IntegrityTest < ActiveSupport::TestCase

  test 'no multiple matches for user_agent samples' do
    agent_samples.each do |name, samples|
      if samples['user_agents']
        samples['user_agents'].each do |sample|
          sample_matches = matches('user_agent_match', sample)
          assert_equal 1, sample_matches.length, "#{sample} has a matching issue"
        end
      end
    end
  end

  test 'no multiple matches for referrer samples' do
    agent_samples.each do |name, samples|
      if samples['referrers']
        samples['referrers'].each do |sample|
          sample_matches = matches('referrer_match', sample)
          assert_equal 1, sample_matches.length, "#{sample} has a matching issue"
        end
      end
    end
  end

  test 'no duplicate name entries' do
    agent_names = PodcastAgentParser.database.map {|agent| agent['name']}
    assert_equal agent_names.length, agent_names.uniq.length
  end

  private

    def matches(attr, string)
      matches = PodcastAgentParser.database.select do |attrs|
        string =~ Regexp.new(attrs[attr]) if attrs[attr]
      end
    end

end
