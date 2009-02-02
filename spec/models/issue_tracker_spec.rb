require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IssueTracker do
  before(:each) do
    @valid_attributes = {
      :project_id => "1",
      :active => false,
      :use_internal => false,
      :external_url => "value for external_url"
    }
  end

  it "should create a new instance given valid attributes" do
    IssueTracker.create!(@valid_attributes)
  end
end
