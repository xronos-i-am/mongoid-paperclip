require "spec_helper"

describe 'Normal' do  
  it 'saves file' do
    t = MyTest.create!(test: @file)
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
