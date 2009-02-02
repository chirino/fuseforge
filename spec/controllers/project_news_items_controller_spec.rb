require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../spec_controller_helper')

describe ProjectNewsItemsController do
  include AuthenticateSpecHelper
  
  def mock_news_item(stubs={})
    @mock_news_item ||= mock_model(ProjectNewsItem, stubs)
  end
  
  before(:each) do
    @project = mock_model(Project)
    @project.stub_association!(:news_items, :find => mock_news_item)
    Project.stub!(:find).and_return(@project)
  end  

  describe "when user" do
    describe "not logged in" do
      it "all actions except :index and :show should fail" do
        controller_actions_should_fail_if_not_logged_in :except => ['index', 'show']
      end  
    end

    describe "not an administrator of the project" do
      it "all actions except :index and :show should fail" do
        controller_actions_should_fail_if_not_project_administrator_for :except => ['index', 'show']
      end  
    end
  end

  describe "responding to GET index" do
    it "should expose all project_news_items as @project_news_items" do
      @project.should_receive(:news_items).and_return([mock_news_item])
      get :index 
      assigns[:project_news_items].should == [mock_news_item]
    end

    it "should render index template'" do
      get :index 
      response.should render_template(:index)
    end
  end

  describe "responding to GET new" do
    it "should expose a new project_news_item as @project_news_item" do
      ProjectNewsItem.should_receive(:new).and_return(mock_news_item)
      do_action_with_project_administrator_for :get, :new, {}
      assigns[:project_news_item].should equal(mock_news_item)
    end

    it "should render new template'" do
      do_action_with_project_administrator_for :get, :new, {} 
      response.should render_template(:new)
    end
  end

  describe "responding to GET edit" do
    before(:each) do
      ProjectNewsItem.stub!(:find).and_return(mock_news_item)
    end

    it "should expose the requested project_news_item as @project_news_item" do
      @project.news_items.should_receive(:find).with("37").and_return(mock_news_item)
      do_action_with_project_administrator_for :get, :edit, { :id => "37" } 
      assigns[:project_news_item].should equal(mock_news_item)
    end

    it "should render edit template'" do
      do_action_with_project_administrator_for :get, :edit, { :id => "37" } 
      response.should render_template(:edit)
    end
  end

  describe "responding to POST create" do
    before(:each) do
      mock_news_item.stub!(:save => true)
      mock_news_item.stub!(:project= => true)
    end
        
    describe "with valid params" do
      it "should expose a newly created project_news_item as @project_news_item" do
        ProjectNewsItem.should_receive(:new).with({'these' => 'params'}).and_return(mock_news_item)
        do_action_with_project_administrator_for :post, :create, { :project_news_item => { :these => 'params' } }
        assigns(:project_news_item).should equal(mock_news_item)
      end

      it "should redirect to the created project_news_item" do
        ProjectNewsItem.stub!(:new).and_return(mock_news_item)
        do_action_with_project_administrator_for :post, :create, { :project_news_item => {} }
        response.should redirect_to(project_project_news_item_url(:project_id => @project, :id => mock_news_item))
      end
    end

    describe "with invalid params" do
      before(:each) do
        mock_news_item.stub!(:save => false)
        mock_news_item.stub!(:project= => true)
      end
      
      it "should expose a newly created but unsaved project_news_item as @project_news_item" do
        ProjectNewsItem.stub!(:new).with({'these' => 'params'}).and_return(mock_news_item)
        do_action_with_project_administrator_for :post, :create, { :project_news_item => { :these => 'params' } }
        assigns(:project_news_item).should equal(mock_news_item)
      end

      it "should re-render the 'new' template" do
        ProjectNewsItem.stub!(:new).and_return(mock_news_item)
        do_action_with_project_administrator_for :post, :create, { :project_news_item => {} }
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      before(:each) do
        mock_news_item.stub!(:update_attributes).and_return(true)
      end
      
      it "should update the requested news_item" do
        mock_news_item.should_receive(:update_attributes).with({ 'these' => 'params' })
        do_action_with_project_administrator_for :put, :update, { :id => "37", :project_news_item => { :these => 'params' } }
      end

      it "should expose the requested project_news_item as @project_news_item" do
        do_action_with_project_administrator_for :put, :update, { :id => "37" }
        assigns(:project_news_item).should equal(mock_news_item)
      end

      it "should redirect to the project_news_item" do
        do_action_with_project_administrator_for :put, :update, { :id => "37" }
        response.should redirect_to(project_project_news_item_url(:project_id => @project.id, :id => mock_news_item.id))
      end
    end

    describe "with invalid params" do
      before(:each) do
        mock_news_item.stub!(:update_attributes).and_return(false)
      end
      
      it "should update the requested news_item" do
        mock_news_item.should_receive(:update_attributes).with({'these' => 'params'})
        do_action_with_project_administrator_for :put, :update, { :id => "37", :project_news_item => {:these => 'params'} }
      end

      it "should expose the project_news_item as @project_news_item" do
        do_action_with_project_administrator_for :put, :update, { :id => "37" }
        assigns(:project_news_item).should equal(mock_news_item)
      end

      it "should re-render the 'edit' template" do
        do_action_with_project_administrator_for :put, :update, { :id => "37" }
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested news_item" do
      mock_news_item.should_receive(:destroy)
      do_action_with_project_administrator_for :delete, :destroy, { :id => "37", :project_id => @project.id }
    end

    it "should redirect to the project_news_items list" do
      mock_news_item.stub!(:destroy)
      do_action_with_project_administrator_for :delete, :destroy, { :id => "37", :project_id => '1' }
      response.should redirect_to(project_project_news_items_url(:project_id => @project.id))
    end
  end
end
