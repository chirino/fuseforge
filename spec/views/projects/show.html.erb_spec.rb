require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/projects/show.html.erb" do
  include ProjectsHelper
  
  before(:each) do
    assigns[:project] = @project = stub_model(Project,
      :name => "value for name",
      :shortname => "value for shortname",
      :description => "value for description"
    )
  end

  it "should render attributes in <p>" do
    render "/projects/show.html.erb"
    response.should have_text(/value\ for\ name/)
    response.should have_text(/value\ for\ shortname/)
    response.should have_text(/value\ for\ description/)
  end
end

