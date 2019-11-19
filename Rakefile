require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"

desc "Clean up Podcast Agents Database"
task :cleanup do
  puts 'Cleaning up database'
  require 'podcast_agent_parser'
  require 'json'

  database = PodcastAgentParser.database.sort_by {|h| [h['bot'].to_s, h['name'].downcase] }
  File.open('lib/data/podcast_agents.yml', "w") { |file| file.write(database.to_yaml) }
  File.open('lib/data/podcast_agents.json', "w") { |file| file.write(JSON.pretty_generate(database)) }

  samples = YAML.load_file('test/data/samples.yml')
  samples = Hash[ samples.sort_by {|name, hash| name.downcase } ]
  File.open('test/data/samples.yml', "w") { |file| file.write(samples.to_yaml) }
  File.open('test/data/samples.json', "w") { |file| file.write(JSON.pretty_generate(samples)) }
end

Rake::TestTask.new do |test|
  Rake::Task[:cleanup].invoke
  test.libs << "test"
  test.test_files = FileList["test/*_test.rb"]
  test.warning = false
end

task default: :test
