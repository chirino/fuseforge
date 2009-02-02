require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/project_news_items/index.html.erb" do
  include ProjectNewsItemsHelper
  
  before(:each) do
    assigns[:project_news_items] = [
      stub_model(ProjectNewsItem, :title => "value for title", :contents => "value for contents"),
      stub_model(ProjectNewsItem, :title => "value for title", :contents => "value for contents")
    ]
  end

  it "should render list of project_news_items" do
    render "/project_news_items/index.html.erb"
    response.should have_tag("tr>td", "value for title", 2)
    response.should have_tag("tr>td", "value for contents", 2)
  end
end

