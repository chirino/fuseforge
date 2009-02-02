require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/prospective_project_members/edit.html.erb" do
  include ProspectiveProjectMembersHelper
  
  before(:each) do
    assigns[:prospective_project_member] = @prospective_project_member = stub_model(ProspectiveProjectMember, :new_record? => false)
  end

  it "should render edit form" do
    render "/prospective_project_members/edit.html.erb"
    
    response.should have_tag("form[action=#{prospective_project_member_path(@prospective_project_member)}][method=post]") do
    end
  end
end


