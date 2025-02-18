# frozen_string_literal: true

lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "gpx2obj/version"

Gem::Specification.new do |spec|
  spec.name = "Gpx2Obj"
  spec.version = Gpx2Obj::VERSION
  spec.license = "MIT"
  spec.authors = ["Daniel Senff"]
  spec.email = ["mail@danielsenff.de"]
  spec.homepage = "http://github.com/Dahie/caramelize"
  spec.summary = "Flexible and modular wiki conversion tool"
  spec.description = "With Caramelize you can migrate any wiki to git-based Gollum wiki repositories."

  spec.files = `git ls-files -z`.split("\x0")
  spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.required_ruby_version = ">= 3"

  spec.add_dependency("kaitai-struct")

  spec.metadata["rubygems_mfa_required"] = "true"
end
