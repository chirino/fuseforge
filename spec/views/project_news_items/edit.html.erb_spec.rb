require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/project_news_items/edit.html.erb" do
  include ProjectNewsItemsHelper
  
  before(:each) do
    assigns[:project_news_item] = @project_news_item = stub_model(ProjectNewsItem, :new_record? => false, :title => "value for title",
     :contents => "value for contents")
  end

  it "should render edit form" do
    render "/project_news_items/edit.html.erb"
    
    response.should have_tag("form[action=#{project_news_item_path(@project_news_item)}][method=post]") do
      with_tag('input#project_news_item_title[name=?]', "project_news_item[title]")
      with_tag('textarea#project_news_item_contents[name=?]', "project_news_item[contents]")
    end
  end
end


