# frozen_string_literal: true

require_relative "lib/pgerd/version"

Gem::Specification.new do |spec|
  spec.name = "pg-erd"
  spec.version = Pgerd::VERSION
  spec.authors = ["Tijn Schuurmans", "Carld"]
  spec.email = ["pg-erd@tijnschuurmans.nl"]

  spec.summary = "Generate ERDs from Postgresql Databases"
  spec.description = "Generate Entity-Relationship Diagrams from Postgresql Databases"

  spec.homepage = "https://github.com/tijn/pg-erd"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/tijn/pg-erd"
  spec.metadata["changelog_uri"] = "https://github.com/tijn/pg-erd/releases"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "bin"
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'pg'
  spec.add_dependency 'ruby-graphviz'
  spec.add_dependency 'ruby-progressbar'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
