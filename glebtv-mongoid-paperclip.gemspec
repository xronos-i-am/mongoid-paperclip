# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mongoid-paperclip/version'

Gem::Specification.new do |gem|
  gem.name        = 'glebtv-mongoid-paperclip'
  gem.version     = Mongoid::Paperclip::VERSION
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['GlebTV', 'Michael van Rooijen']
  gem.email       = 'meskyanichi@gmail.com'
  gem.homepage    = 'https://github.com/glebtv/mongoid-paperclip'
  gem.summary     = 'Fork of Mongoid::Paperclip'
  gem.description = 'Mongoid::Paperclip enables you to use Paperclip with the Mongoid ODM for MongoDB.'

  gem.files         = %x[git ls-files].split("\n")
  gem.test_files    = %x[git ls-files -- {spec}/*].split("\n")
  gem.require_paths = ['lib']

  # pinned because of https://github.com/thoughtbot/paperclip/issues/1845
  gem.add_dependency 'paperclip', ['>= 3.4', '!= 4.3.0']
  gem.add_dependency "mongoid", [">= 3.0", "< 6.0"]
  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rake"
end

