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
Mongoid.logger = Logger.new($stdout)

Moped.logger = Logger.new($stdout)
Moped.logger.level = Logger::DEBUG

RSpec.configure do |config|
  config.before(:all) do
    @file = File.open(File.join(File.dirname(__FILE__), "support", '1024x768.gif'))
  end
end
