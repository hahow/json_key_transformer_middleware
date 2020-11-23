require 'date'

module JsonKeyTransformerMiddleware
  VERSION = File.read(File.expand_path('../VERSION', __FILE__)).strip
end

Gem::Specification.new do |gem|
  gem.name        = 'json_key_transformer_middleware'
  gem.version     = JsonKeyTransformerMiddleware::VERSION
  gem.date        = Date.today.strftime('%Y-%m-%d')
  gem.summary     = 'Rack middleware which transforms incoming and outgoing JSON keys to support the development of Rails JSON-based APIs'
  gem.description = 'Incoming JSON keys are transformed from camelCase to snake_case. Outgoing JSON keys are transformed from snake_case to camelCase.'
  gem.author      = ['Kevin Rood']
  gem.files       = `git ls-files LICENSE readme.md *.rb`.split($/)
  gem.homepage    = 'https://github.com/kevinrood/json_key_transformer_middleware'
  gem.license     = 'Apache-2.0'

  gem.add_runtime_dependency('hash_key_transformer', '~> 0.1.3')
  gem.add_runtime_dependency('oj', '~> 3.0')
  gem.add_runtime_dependency('oj_mimic_json', '~> 1.0')
  gem.add_runtime_dependency('rails', '~> 6.0')
end
