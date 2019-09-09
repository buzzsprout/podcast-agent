require 'test_helper'

class IntegrityTest < ActiveSupport::TestCase

  test 'no multiple matches for name samples' do
    user_agent_samples.each do |name, samples|
      if samples['user_agents']
        samples['user_agents'].each do |sample|
          matches = PodcastAgent.database.select do |attrs|
            sample =~ Regexp.new(attrs['user_agent_match'])
          end
          assert_equal 1, matches.length, "'#{sample}' has multiple matches"
        end
      end
    end
  end

  test 'no duplicate name entries' do
    agent_names = PodcastAgent.database.map {|agent| agent['name']}
    assert_equal agent_names.length, agent_names.uniq.length
  end

end
