require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news_items/index.html.erb" do
  include NewsItemsHelper
  
  before(:each) do
    assigns[:news_items] = [
      stub_model(NewsItem, :title => "value for title", :contents => "value for contents"),
      stub_model(NewsItem, :title => "value for title", :contents => "value for contents")
    ]
  end

  it "should render list of news_items" do
    render "/news_items/index.html.erb"
    response.should have_tag("tr>td", "value for title", 2)
    response.should have_tag("tr>td", "value for contents", 2)
  end
end

