require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProspectiveProjectMember do
  before(:each) do
    @valid_attributes = {
      :project_id => "1",
      :user_id => "1"
    }
  end

  it "should create a new instance given valid attributes" do
    ProspectiveProjectMember.create!(@valid_attributes)
  end
end
