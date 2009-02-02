require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/featured_projects/index.html.erb" do
  include FeaturedProjectsHelper
  
  before(:each) do
    assigns[:featured_projects] = [
      stub_model(FeaturedProject,
        :position => "1"
      ),
      stub_model(FeaturedProject,
        :position => "1"
      )
    ]
  end

  it "should render list of featured_projects" do
    render "/featured_projects/index.html.erb"
    response.should have_tag("tr>td", "1", 2)
  end
end

