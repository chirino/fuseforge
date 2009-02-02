require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/prospective_project_members/new.html.erb" do
  include ProspectiveProjectMembersHelper
  
  before(:each) do
    assigns[:prospective_project_member] = stub_model(ProspectiveProjectMember, :new_record? => true)
  end

  it "should render new form" do
    render "/prospective_project_members/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", prospective_project_members_path) do
    end
  end
end


