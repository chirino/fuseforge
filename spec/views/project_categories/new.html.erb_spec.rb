require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/project_categories/new.html.erb" do
  include ProjectCategoriesHelper
  
  before(:each) do
    assigns[:project_category] = stub_model(ProjectCategory,
      :new_record? => true,
      :name => "value for name",
      :description => "value for description",
      :position => "1"
    )
  end

  it "should render new form" do
    render "/project_categories/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", project_categories_path) do
      with_tag("input#project_category_name[name=?]", "project_category[name]")
      with_tag("input#project_category_description[name=?]", "project_category[description]")
      with_tag("input#project_category_position[name=?]", "project_category[position]")
    end
  end
end


