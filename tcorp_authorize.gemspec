# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'tcorp_authorize/version'
require 'rquest'

Gem::Specification.new do |spec|
  spec.name          = "tcorp_authorize"
  spec.version       = TcorpAuthorize::VERSION
  spec.authors       = ["The Tyrel Corporation"]
	spec.email         = ["cloud.tycorp@gmail.com"]

  spec.summary       = %q{A non explicit rest client for authorize payments}
  spec.description   = %q{This is an unofficial rest client gem for the Authroize payment gateway service. The official version does not allow for submission of extra info like billing and shipping information and customer meta data like their email. Maybe the offical gem could be hacked but we opted instead to make this gem. We will add all of the authorize features as well as documentation in the future. Right now the specs should provide our two supported use cases. We hope this helps.}
  spec.homepage      = "https://github.com/thetyrelcorporation/tcorp_authorize"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
	spec.add_development_dependency "guard"
	spec.add_development_dependency "guard-rspec"
	spec.add_runtime_dependency  "rquest"	
end
