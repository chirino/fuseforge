require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IssuesProject do
  it "should initialize a new instance given valid attributes" do
    IssuesProject.new(1).should be_an_instance_of(IssuesProject)
  end
  
  it "should have issues" do
    IssuesProject.new(1).issues.first.should be_an_instance_of(Issue)
  end

  it "should be able to create a new project in the issue tracking software"
  
  it "should be able to add Crowd groups to a project in the issue tracking software"
  
  it "should be able to set permissions for a Crowd group within a project in the issue tracking software"
end
