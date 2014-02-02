ROOT = File.join(File.dirname(__FILE__), "..")
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(ROOT, "lib"))

require "rubygems"
require "rspec"
require "mongoid"
require "mongoid-paperclip"

Paperclip::Attachment.default_options.merge!({
  path: "#{ROOT}/tmp/:attachment/:id/:style/:filename",
  url: "/tmp/:attachment/:id/:style/:filename"
})

Mongoid.configure do |config|
  config.connect_to "mongoid-paperclip"
end
Paperclip.options[:log] = false

#Mongoid.logger = Logger.new($stdout)
#Moped.logger = Logger.new($stdout)
#Moped.logger.level = Logger::DEBUG

class MyTest
  include Mongoid::Document
  include Mongoid::Paperclip
  has_mongoid_attached_file :test
  validates_attachment_content_type :test, :content_type => ['image/gif']
  
  embeds_many :examples
  embeds_many :t_tests
end

class TTest
  include Mongoid::Document
  include Mongoid::Timestamps::Short
  embedded_in :my_test
end

class Example
  include Mongoid::Document
  include Mongoid::Paperclip
  embedded_in :my_test
  field :name
  has_mongoid_attached_file :test
  do_not_validate_attachment_file_type :test
end

RSpec.configure do |config|
  config.before(:all) do
    @file = File.open(File.join(File.dirname(__FILE__), "support", '1024x768.gif'))
  end
end
