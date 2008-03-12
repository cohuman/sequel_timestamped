require File.join(File.dirname(__FILE__), "spec_helper")

DB = Sequel.sqlite
 

class TimestampedModel < Sequel::Model(:items)
  set_schema do
    primary_key :id
    varchar :name
    datetime :created_at
    datetime :updated_at
  end

  is :timestamped
end

class NonTimestampedModel < Sequel::Model(:items)
  set_schema do
    primary_key :id
    varchar :name
  end

  is :timestamped
end

describe Sequel::Plugins::Timestamped, "#created_at" do

  before(:each) do
    TimestampedModel.create_table!
  end
  
  it "should handle a model without a created_at field" do
    NonTimestampedModel.create.should be_valid
  end

  it "should set created_at to Time.now on INSERT" do
    TimestampedModel.create.created_at.should_not be_nil
  end
  

  it "should set updated_at to Time.now on INSERT" do
    TimestampedModel.create.updated_at.should_not be_nil
  end
  

end

describe Sequel::Plugins::Timestamped, "#updated_at" do

  it "should set updated_at to Time.now upon UPDATE" do
    t = TimestampedModel.create
    t.updated_at = nil
    t.save
    t.updated_at.should_not be_nil
  end
  
  it "should handle a model without an updated_at field" do
    nt = NonTimestampedModel.create
    nt.name = "hi"
    nt.save
    nt.should be_valid
  end

end
