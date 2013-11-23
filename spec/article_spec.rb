require "spec_helper"

class MyTest
  include Mongoid::Document
  include Mongoid::Paperclip
  has_mongoid_attached_file :test
  embeds_many :examples
end

class Example
  include Mongoid::Document
  include Mongoid::Paperclip
  embedded_in :my_test
  field :name
  has_mongoid_attached_file :test
end

describe 'Normal' do  
  it 'saves file' do
    t = MyTest.create!(test: @file)
  end
end

describe 'Embedded' do
  it 'deletion works' do
    pr = MyTest.create!
    5.times do |t|
      pr.examples.create!(name: t.to_s, test: @file)
    end
    pr.examples.length.should eq 5
    pr.examples.destroy_all
    pr.reload
    pr.examples.length.should eq 0
  end
end
