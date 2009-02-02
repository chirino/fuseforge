require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/featured_projects/show.html.erb" do
  include FeaturedProjectsHelper
  
  before(:each) do
    assigns[:featured_project] = @featured_project = stub_model(FeaturedProject,
      :position => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/featured_projects/show.html.erb"
    response.should have_text(/1/)
  end
end

