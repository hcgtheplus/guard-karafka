# frozen_string_literal: true

require_relative "lib/karafka/version"

Gem::Specification.new do |spec|
  spec.name = "guard-karafka"
  spec.version = Guard::KarafkaVersion::VERSION
  spec.authors = ["aucun"]
  spec.email = ["gglee6352@gmail.com"]

  spec.summary = %q{guard gem for karafka}
  spec.description = %q{Guard::Karafka automatically starts/stops/restarts karafka server}
  # spec.homepage = "TODO: Put your gem's website or public repo URL here."
  spec.required_ruby_version = ">= 2.6.0"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'guard-compat', '~> 1.1'
  spec.add_dependency 'karafka', '>= 2.4'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end