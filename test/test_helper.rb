# $LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'active_support'
require 'active_support/testing/autorun'

require 'podcast_agent'

class ActiveSupport::TestCase

    private

      def user_agent_samples
        @user_agent_samples ||=
                   YAML.load_file('test/sample_user_agents.yml')
      end

      def user_agents
        @user_agents ||=
                   YAML.load_file('lib/user_agents.yml')
      end

end