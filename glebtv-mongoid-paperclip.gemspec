# encoding: utf-8

Gem::Specification.new do |gem|

  gem.name        = 'glebtv-mongoid-paperclip'
  gem.version     = '0.0.8'
  gem.platform    = Gem::Platform::RUBY
  gem.authors     = ['GlebTV', 'Michael van Rooijen']
  gem.email       = 'meskyanichi@gmail.com'
  gem.homepage    = 'https://github.com/glebtv/mongoid-paperclip'
  gem.summary     = 'Fork of Mongoid::Paperclip'
  gem.description = 'Mongoid::Paperclip enables you to use Paperclip with the Mongoid ODM for MongoDB.'

  gem.files         = %x[git ls-files].split("\n")
  gem.test_files    = %x[git ls-files -- {spec}/*].split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'paperclip', ['>= 2.3.6']

end

