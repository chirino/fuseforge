require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectCategory do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :description => "value for description",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProjectCategory.create!(@valid_attributes)
  end
end
