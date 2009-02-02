require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/featured_projects/new.html.erb" do
  include FeaturedProjectsHelper
  
  before(:each) do
    assigns[:featured_project] = stub_model(FeaturedProject,
      :new_record? => true,
      :position => "1"
    )
  end

  it "should render new form" do
    render "/featured_projects/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", featured_projects_path) do
      with_tag("input#featured_project_position[name=?]", "featured_project[position]")
    end
  end
end


