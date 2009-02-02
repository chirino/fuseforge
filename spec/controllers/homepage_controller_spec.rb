require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HomepageController do

  before(:each) do
    FeaturedProject.stub!(:projects).and_return([mock_model(Project)])
    FuseforgeNewsItem.stub!(:recent).and_return([mock_model(ProjectNewsItem), mock_model(NewsItem)])
    FusesourceNewsItem.stub!(:recent).and_return([mock_model(FusesourceNewsItem)])
  end

  describe "responding to GET index" do
    it "should assign instance vars" do
      get :index
      assigns[:featured_projects].should == FeaturedProject.projects
      assigns[:fuseforge_news_items].should == FuseforgeNewsItem.recent
      assigns[:fusesource_news_items].should == FusesourceNewsItem.recent
    end

    it "should render index template'" do
      get :index
      response.should render_template(:index)
    end
  end
end
