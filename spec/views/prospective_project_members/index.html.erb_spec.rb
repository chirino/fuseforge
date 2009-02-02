require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/prospective_project_members/index.html.erb" do
  include ProspectiveProjectMembersHelper
  
  before(:each) do
    assigns[:prospective_project_members] = [
      stub_model(ProspectiveProjectMember),
      stub_model(ProspectiveProjectMember)
    ]
  end

  it "should render list of prospective_project_members" do
    render "/prospective_project_members/index.html.erb"
  end
end

