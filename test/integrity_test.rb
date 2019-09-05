require 'test_helper'

class IntegrityTest < ActiveSupport::TestCase

  test 'no multiple matches for name samples' do
    user_agent_samples.each do |name, samples|
      samples.each do |sample|
        matches = PodcastAgent.database.select do |attrs|
          sample =~ Regexp.new(attrs['regex'])
        end
        assert_equal 1, matches.length, "'#{sample}' has multiple matches"
      end
    end
  end

  test 'no duplicate name entries' do
    assert_equal PodcastAgent.database.map(&:first).length, PodcastAgent.database.map(&:first).uniq.length
  end

end
