Gem::Specification.new do |gem|
  gem.name          = 'ringcentral-sdk'
  gem.version       = '1.0.0-beta.2'
  gem.authors       = ['Tyler Liu']
  gem.email         = ['tyler.liu@ringcentral.com']
  gem.description   = 'Ruby SDK for you to access RingCentral platform API.'
  gem.summary       = 'RingCentral Ruby SDK.'
  gem.homepage      = 'https://github.com/ringcentral/ringcentral-ruby'
  gem.license       = 'MIT'

  gem.require_paths = ['lib']
  gem.files         = %w(README.md ringcentral-sdk.gemspec)
  gem.files        += Dir['lib/**/*.rb']
  gem.test_files    = Dir['spec/**/*.rb']

  gem.add_dependency('addressable')
  gem.add_dependency('concurrent-ruby')
  gem.add_dependency('faraday')
  gem.add_dependency('faraday-multipart')
  gem.add_dependency('faye-websocket')
end
