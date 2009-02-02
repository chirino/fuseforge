require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/prospective_project_members/show.html.erb" do
  include ProspectiveProjectMembersHelper
  
  before(:each) do
    assigns[:prospective_project_member] = @prospective_project_member = stub_model(ProspectiveProjectMember)
  end

  it "should render attributes in <p>" do
    render "/prospective_project_members/show.html.erb"
  end
end

