# $LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'active_support'
require 'active_support/testing/autorun'

require 'podcast_agent_parser'
require 'byebug'

class ActiveSupport::TestCase

  private

    def agent_samples
      @agent_samples ||= YAML.load_file('test/data/samples.yml')
    end

    def devices
      @devices ||= YAML.load_file('test/data/devices.yml')
    end
end
