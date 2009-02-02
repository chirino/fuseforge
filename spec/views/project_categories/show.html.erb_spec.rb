require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/project_categories/show.html.erb" do
  include ProjectCategoriesHelper
  
  before(:each) do
    assigns[:project_category] = @project_category = stub_model(ProjectCategory,
      :name => "value for name",
      :description => "value for description",
      :position => "1"
    )
  end

  it "should render attributes in <p>" do
    render "/project_categories/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ description/)
    response.should have_text(/1/)
  end
end

