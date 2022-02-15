require_relative 'lib/dynoscale_agent/version'

Gem::Specification.new do |spec|
  spec.name          = "dynoscale_agent"
  spec.version       = DynoscaleAgent::VERSION
  spec.authors       = ["Eric Abrahamsen"]
  spec.email         = ["eric@dynoscale.com"]

  spec.summary       = "This gem is an agent for the Dynoscale Heroku add-on."
  spec.homepage      = "https://www.dynoscale.com"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata = {
    "homepage_uri" => "https://dynoscale.net",
    "bug_tracker_uri" => "https://github.com/Mjolnir-Software/dynoscale_agent/issues",
    "documentation_uri" => "https://dynoscale.net/getting_started",
    "changelog_uri" => "https://github.com/Mjolnir-Software/dynoscale_agent/blob/master/CHANGELOG.md",
    "source_code_uri" => "https://github.com/Mjolnir-Software/dynoscale_agent",
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
