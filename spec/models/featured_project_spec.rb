require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe FeaturedProject do
  before(:each) do
    @valid_attributes = {
      :project_id => "1",
      :position => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    FeaturedProject.create!(@valid_attributes)
  end
end
