require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/project_news_items/new.html.erb" do
  include ProjectNewsItemsHelper
  
  before(:each) do
    assigns[:project_news_item] = stub_model(ProjectNewsItem, :new_record? => true, :title => "value for title", 
     :contents => "value for contents")
  end

  it "should render new form" do
    render "/project_news_items/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", project_news_items_path) do
      with_tag("input#project_news_item_title[name=?]", "project_news_item[title]")
      with_tag("textarea#project_news_item_contents[name=?]", "project_news_item[contents]")
    end
  end
end


