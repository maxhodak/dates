$:.unshift File.expand_path("../lib", __FILE__)
require 'version'

Gem::Specification.new do |gem|
  gem.name    = "dates"
  gem.version = Dates::VERSION

  gem.author      = "Max Hodak, Daphne Ezer"
  gem.email       = "maxhodak@gmail.com"
  gem.homepage    = "http://www.github.com/maxhodak/dates"
  gem.summary     = "Dates keeps track of things you two have been meaning to do."
  gem.description = "Dates keeps track of things you two have been meaning to do, and learns to make good suggestions as you teach it."
  gem.executables = "dates"

  gem.files = %x{ git ls-files }.split("\n").select { |d| d =~ %r{^(README|bin/|lib/|test/)} }

  gem.add_dependency "statsample"
  gem.add_dependency "colorize"
  gem.add_dependency "trollop"
end