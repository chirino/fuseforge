require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/project_news_items/show.html.erb" do
  include ProjectNewsItemsHelper
  
  before(:each) do
    assigns[:project_news_item] = @project_news_item = stub_model(ProjectNewsItem, :title => "value for title", 
     :contents => "value for contents")
  end

  it "should render attributes in <p>" do
    render "/project_news_items/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ contents/)
  end
end

