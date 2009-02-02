require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe CrowdGroup do
  before(:each) do
    @group = CrowdGroup.new('delete-this-group')
  end

  it "should initialize a new instance given valid attributes" do
    Crowd.new.should be_an_instance_of(Crowd)
  end
  
  it "should be able to create a new Crowd group" do
    @group.exists_in_crowd?.should be_false
    @group.add_to_crowd
    @group.exists_in_crowd?.should be_true
  end
  
  it "should be able to remove a Crowd group" do
    @group.add_to_crowd
    @group.exists_in_crowd?.should be_true
    @group.remove_from_crowd
    @group.exists_in_crowd?.should be_false
  end
  
  it "should be able to add a user to a Crowd group" do
    @group.users.should_not include(users(:one))
    @group.add_user(users(:one))
    @group.users.should include(users(:one))
  end  
  
  it "should be able to remove a user from a Crowd group" do
    @group.add_user(users(:one))
    @group.users.should include(users(:one))
    @group.remove_user(users(:one))
    @group.users.should_not include(users(:one))
  end  

end
