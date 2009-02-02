require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news_items/new.html.erb" do
  include NewsItemsHelper
  
  before(:each) do
    assigns[:news_item] = stub_model(NewsItem, :new_record? => true, :title => "value for title", :contents => "value for contents")
  end

  it "should render new form" do
    render "/news_items/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", news_items_path) do
      with_tag("input#news_item_title[name=?]", "news_item[title]")
      with_tag("textarea#news_item_contents[name=?]", "news_item[contents]")
    end
  end
end


