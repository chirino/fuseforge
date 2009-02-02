require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/featured_projects/edit.html.erb" do
  include FeaturedProjectsHelper
  
  before(:each) do
    assigns[:featured_project] = @featured_project = stub_model(FeaturedProject,
      :new_record? => false,
      :position => "1"
    )
  end

  it "should render edit form" do
    render "/featured_projects/edit.html.erb"
    
    response.should have_tag("form[action=#{featured_project_path(@featured_project)}][method=post]") do
      with_tag('input#featured_project_position[name=?]', "featured_project[position]")
    end
  end
end


