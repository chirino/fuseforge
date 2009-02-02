require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/news_items/edit.html.erb" do
  include NewsItemsHelper
  
  before(:each) do
    assigns[:news_item] = @news_item = stub_model(NewsItem, :new_record? => false, :title => "value for title",
     :contents => "value for contents")
  end

  it "should render edit form" do
    render "/news_items/edit.html.erb"
    
    response.should have_tag("form[action=#{news_item_path(@news_item)}][method=post]") do
      with_tag('input#news_item_title[name=?]', "news_item[title]")
      with_tag('textarea#news_item_contents[name=?]', "news_item[contents]")
    end
  end
end


