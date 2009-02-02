require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news_items/show.html.erb" do
  include NewsItemsHelper
  
  before(:each) do
    assigns[:news_item] = @news_item = stub_model(NewsItem, :title => "value for title", :contents => "value for contents")
  end

  it "should render attributes in <p>" do
    render "/news_items/show.html.erb"
    response.should have_text(/value\ for\ title/)
    response.should have_text(/value\ for\ contents/)
  end
end

