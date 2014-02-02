require "spec_helper"

describe 'Normal' do  
  it 'saves file' do
    t = MyTest.create!(test: @file)
    t.test_content_type.should eq 'image/gif'
    t.test_file_size.should eq 4357
    t.test_fingerprint.should eq 'ad440d5012228c0ea65dab7e0d4bce28'
  end
end

describe 'Embedded' do
  it 'deletion works wo paperclip' do
    pr = MyTest.create!
    2.times do |t|
      pr.examples.create!(name: t.to_s)
    end
    pr.examples.length.should eq 2
    pr.examples.destroy_all
    pr.reload
    pr.examples.length.should eq 0
    MyTest.destroy_all
  end
  
  it 'deletion works with ts' do
    pr = MyTest.create!
    2.times do |t|
      pr.t_tests.create!
    end
    pr.t_tests.length.should eq 2
    pr.t_tests.destroy_all.should eq 2
    pr.reload
    pr.t_tests.length.should eq 0
  end
  
  it 'deletion works' do
    pr = MyTest.create!
    2.times do |t|
      pr.examples.create!(name: t.to_s, test: @file)
    end
    pr.examples.length.should eq 2
    pr.examples.destroy.should eq 2
    pr.examples.length.should eq 0
    pr.reload
    pr.examples.length.should eq 0
  end
  
  it 'deletion works' do
    pr = MyTest.create!
    2.times do |t|
      pr.examples.create!(name: t.to_s, test: @file)
    end
    pr.examples.first.destroy
    pr.reload
    pr.examples.length.should eq 1
  end
  
  pending 'deletion works' do
    pr = MyTest.create!
    2.times do |t|
      pr.examples.create!(name: t.to_s, test: @file)
    end
    pr.examples.destroy_all.should eq 2
    pr.reload
    pr.examples.length.should eq 1
  end
end
