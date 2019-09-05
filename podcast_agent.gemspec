Gem::Specification.new do |s|
  s.name        = 'podcast-agent'
  s.version     = '0.0.1'
  s.date        = '2019-08-21'
  s.summary     = "A GEM to identify podcast agent information"
  s.description = "A GEM to identify podcast agent information"
  s.authors     = ["Tom Rossi"]
  s.email       = 'tom@higherpixels.com'
  s.homepage    = 'https://github.com/higher-pixels/podcast-agent'
  s.license     = 'MIT'

  s.required_ruby_version = '>= 2.4.0'

  s.add_dependency 'activesupport', '>= 5.2.0'

  s.add_development_dependency 'bundler', '~> 1.15'

  s.files      = `git ls-files`.split("\n")
  s.test_files = `git ls-files -- test/*`.split("\n")
end