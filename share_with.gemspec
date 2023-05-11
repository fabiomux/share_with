# frozen_string_literal: true

require_relative "lib/share_with/version"

Gem::Specification.new do |spec|
  spec.name = "share_with"
  spec.version = ShareWith::VERSION
  spec.authors = ["Fabio Mucciante"]
  spec.email = ["fabio.mucciante@gmail.com"]

  spec.summary = "Encodes the sharing links from social networks and similar services."
  spec.description = "Model and build up sharing links from yaml files to HTML code."
  spec.homepage = "https://freeaptitude.altervista.org/projects/share-with.html"
  spec.license = "GPL-3.0"
  spec.required_ruby_version = ">= 2.6.0"

  # spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/fabiomux/share_with"
  spec.metadata["changelog_uri"] = "https://freeaptitude.altervista.org/projects/share-with.html#changelog"
  spec.metadata["wiki_uri"] = "https://github.com/fabiomux/share_with/wiki"
  spec.metadata["rubygems_mfa_required"] = "true"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "erb"
  spec.add_dependency "loofah"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
