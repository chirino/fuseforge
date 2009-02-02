require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectNewsItem do
  before(:each) do
    @valid_attributes = {
      :project_id => "1",
      :title => "value for title",
      :contents => "value for contents",
      :created_by_id => "1",
      :updated_by_id => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProjectNewsItem.create!(@valid_attributes)
  end
end
