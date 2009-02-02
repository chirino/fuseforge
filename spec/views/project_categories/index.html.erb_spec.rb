require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/project_categories/index.html.erb" do
  include ProjectCategoriesHelper
  
  before(:each) do
    assigns[:project_categories] = [
      stub_model(ProjectCategory,
        :name => "value for name",
        :description => "value for description",
        :position => "1"
      ),
      stub_model(ProjectCategory,
        :name => "value for name",
        :description => "value for description",
        :position => "1"
      )
    ]
  end

  it "should render list of project_categories" do
    render "/project_categories/index.html.erb"
    response.should have_tag("tr>td", "value for name", 2)
    response.should have_tag("tr>td", "value for description", 2)
    response.should have_tag("tr>td", "1", 2)
  end
end

