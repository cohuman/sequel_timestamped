require File.join(File.dirname(__FILE__), "spec_helper")

DB = Sequel.sqlite

class TimestampedModel < Sequel::Model(:items_timestamped)
  set_schema do
    primary_key :id
    varchar :name
    datetime :created_at
    datetime :updated_at
  end

  is :timestamped
end

class NonTimestampedModel < Sequel::Model(:items_nontimestamped)
  set_schema do
    primary_key :id
    varchar :name
  end

  is :timestamped
end

describe Sequel::Plugins::Timestamped, "#created_at" do
  before(:each) do
    TimestampedModel.create_table!
    NonTimestampedModel.create_table!
  end
  
  it "should handle a model without a created_at field" do
    NonTimestampedModel.create.should be_valid
  end

  it "should set created_at to Time.now on INSERT" do
    TimestampedModel.create.created_at.should_not be_nil
  end
  
  it "should allow to specify custom created_at on INSERT" do
    time_now = Time.now + 3600
    TimestampedModel.create(:created_at => time_now).created_at.to_i.should eql(time_now.to_i)
  end
  
  it "should allow to update created_at" do
    updated_time = Time.now - 1800
    m = TimestampedModel.create
    m.update(:created_at => updated_time).created_at.to_i.should == updated_time.to_i
  end
end

describe Sequel::Plugins::Timestamped, "#updated_at" do
  it "should set updated_at to Time.now on INSERT" do
    TimestampedModel.create.updated_at.should_not be_nil
  end
  
  it "should set updated_at to Time.now upon UPDATE" do
    t = TimestampedModel.create
    t.updated_at = nil
    t.save
    t.updated_at.should_not be_nil
  end
  
  it "should update updated_at on UPDATE" do
    t = TimestampedModel.create
    updated_time = Time.now - 3600
    Time.stub!(:now).and_return(updated_time)
    t.update(:name => 'Oh hai!')
    t.updated_at.to_i.should == updated_time.to_i
  end
    
  it "should handle a model without an updated_at field" do
    nt = NonTimestampedModel.create
    nt.name = "hi"
    nt.save
    nt.should be_valid
  end

  it "should allow to specify custom updated_at on INSERT" do
    time_now = Time.now + 3600
    TimestampedModel.create(:updated_at => time_now).updated_at.to_i.should eql(time_now.to_i)
  end
  
  it "should allow to update updated_at column" do
    updated_time = Time.now - 1800
    m = TimestampedModel.create
    m.update(:updated_at => updated_time).updated_at.to_i.should == updated_time.to_i
  end
end
