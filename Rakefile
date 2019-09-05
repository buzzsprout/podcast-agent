require "bundler/setup"
require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |test|
  test.libs << "test"
  test.test_files = FileList["test/*_test.rb"]
  test.warning = false
end

task default: :test

desc "Clean up Podcast Agents Database"
task :cleanup do
  require 'podcast_agent'
  require 'json'
  database = PodcastAgent.database.sort_by {|h| (h['type']+h['name']).downcase}
  File.open('lib/data/podcast_agents.yml', "w") { |file| file.write(database.to_yaml) }
  File.open('lib/data/podcast_agents.json', "w") { |file| file.write(JSON.pretty_generate(database)) }

  samples ||= YAML.load_file('test/data/sample_user_agents.yml')
  samples.sort_by {|name, arr| name.downcase }
  File.open('test/data/sample_user_agents.yml', "w") { |file| file.write(samples.to_yaml) }
  File.open('test/data/sample_user_agents.json', "w") { |file| file.write(JSON.pretty_generate(samples)) }
end