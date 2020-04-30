lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'telegram-notifier/version'

Gem::Specification.new do |spec|
  spec.name          = 'telegram-notifier'
  spec.version       = Telegram::Notifier::VERSION
  spec.authors       = ['Beanaccle']
  spec.email         = ['25994266+Beanaccle@users.noreply.github.com']

  spec.summary       = 'A slim ruby wrapper for posting to telegram webhooks'
  spec.description   = ' A slim ruby wrapper for posting to telegram webhooks '
  spec.homepage      = 'http://github.com/beanaccle/telegram-notifier'
  spec.license       = 'MIT'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'pry-byebug',    '~> 3.7'
  spec.add_development_dependency 'rake',          '~> 13.0'
  spec.add_development_dependency 'rspec',         '~> 3.9'
  spec.add_development_dependency 'rubocop',       '~> 0.76.0'
  spec.add_development_dependency 'rubocop-rspec', '~> 1.36'
end
