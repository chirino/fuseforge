require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomepageController do

  before(:each) do
    FeaturedProject.stub!(:projects).and_return([mock_model(Project)])
  end

  describe "responding to GET index" do
    it "should assign instance vars" do
      get :index
      assigns[:featured_projects].should == FeaturedProject.projects
    end

    it "should render index template'" do
      get :index
      response.should render_template(:index)
    end
  end
end
