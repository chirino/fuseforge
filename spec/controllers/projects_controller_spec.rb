require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../spec_controller_helper')

describe ProjectsController do
  include AuthenticateSpecHelper

  def mock_project(stubs={})
    @mock_project ||= mock_model(Project, stubs)
  end

  def mock_approved_project
    @mock_approved_project ||= mock_model(Project, :approved? => true, :destroy => true)
  end

  describe "when user" do
    describe "is not logged in" do
      it "all actions except :index and :show should fail" do
        controller_actions_should_fail_if_not_logged_in :except => ['index', 'show']
      end  
    end
    
    describe "is not a project's administrator" do
      before(:each) do
        Project.stub!(:find).and_return(mock_approved_project)
        @project = mock_approved_project
      end

      it "all actions except :index, :show, :new, and :create should fail" do
        controller_actions_should_fail_if_not_project_administrator_for :except => ['index', 'show', 'new', 'create']
      end
    end
    
    describe "not a site administrator" do
      before(:each) do
        Project.stub!(:find).and_return(mock_approved_project)
      end

      it "the :destroy action should fail" do
        controller_actions_should_fail_if_not_site_admin :except => ['index', 'show', 'new', 'create', 'edit', 'update']
      end  
    end
  end
=begin
  describe "responding to GET index" do
    describe "when user is not a site administrator" do
      it "should expose only approved projects as @projects" do
        Project.should_receive(:approved).and_return([mock_project])
        get :index 
        assigns[:projects].should == [mock_project]
      end
    end
    
    describe "when user is a site administrator" do  
      it "should expose all projects as @projects" do
        Project.should_receive(:all).and_return([mock_project])
        get :index 
        assigns[:projects].should == [mock_project]
      end
    end  

    it "should render index template'" do
      get :index 
      response.should render_template(:index)
    end
  end

  describe "responding to GET new" do
    it "should expose a new project as @project" do
      Project.should_receive(:new).and_return(mock_project)
      do_action_with_registered_user :get, :new, {}
      assigns[:project].should equal(mock_project)
    end

    it "should render new template'" do
      do_action_with_registered_user :get, :new, {} 
      response.should render_template(:new)
    end
  end

  describe "responding to GET edit" do
    before(:each) do
      Project.stub!(:find).and_return(mock_project)
    end

    it "should expose the requested project as @project" do
      Project.should_receive(:find).with("37").and_return(mock_project)
      do_action_with_project_administrator_for :get, :edit, { :id => "37" } 
      assigns[:project].should equal(mock_project)
    end

    it "should render edit template'" do
      do_action_with_project_administrator_for :get, :edit, { :id => "37" } 
      response.should render_template(:edit)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created project as @project" do
        Project.should_receive(:new).with({'these' => 'params'}).and_return(mock_project(:save => true))
        do_action_with_registered_user :post, :create, { :project => { :these => 'params' } }
        assigns(:project).should equal(mock_project)
      end

      it "should redirect to the homepage" do
        Project.stub!(:new).and_return(mock_project(:save => true))
        do_action_with_registered_user :post, :create, { :project => {} }
        response.should redirect_to('/')
      end
    end

    describe "with invalid params" do
      it "should expose a newly created but unsaved project as @project" do
        Project.stub!(:new).with({'these' => 'params'}).and_return(mock_project(:save => false))
        do_action_with_registered_user :post, :create, { :project => { :these => 'params' } }
        assigns(:project).should equal(mock_project)
      end

      it "should re-render the 'new' template" do
        Project.stub!(:new).and_return(mock_project(:save => false))
        do_action_with_registered_user :post, :create, { :project => {} }
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      before(:each) do
        Project.stub!(:find).and_return(mock_project(:update_attributes => true))
      end

      it "should update the requested project" do
        Project.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:update_attributes).with({ 'these' => 'params' })
        do_action_with_project_administrator_for :put, :update, { :id => "37", :project => { :these => 'params' } }
      end

      it "should expose the requested project as @project" do
        do_action_with_project_administrator_for :put, :update, { :id => "37" }
        assigns(:project).should equal(mock_project)
      end

      it "should redirect to the project" do
         do_action_with_project_administrator_for :put, :update, { :id => "37" }
        response.should redirect_to(project_url(mock_project))
      end
    end

    describe "with invalid params" do
      before(:each) do
        Project.stub!(:find).and_return(mock_project(:update_attributes => false))
      end

      it "should update the requested project" do
        Project.should_receive(:find).with("37").and_return(mock_project)
        mock_project.should_receive(:update_attributes).with({'these' => 'params'})
        do_action_with_project_administrator_for :put, :update, { :id => "37", :project => {:these => 'params'} }
      end

      it "should expose the project as @project" do
        do_action_with_project_administrator_for :put, :update, { :id => "37" }
        assigns(:project).should equal(mock_project)
      end

      it "should re-render the 'edit' template" do
        do_action_with_project_administrator_for :put, :update, { :id => "37" }
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested project" do
      Project.should_receive(:find).with("37").and_return(mock_project)
      mock_project.should_receive(:destroy)
      do_action_with_site_admin :delete, :destroy, { :id => "37" }
    end

    it "should redirect to the projects list" do
      Project.stub!(:find).and_return(mock_project(:destroy => true))
      do_action_with_site_admin :delete, :destroy, { :id => "37" }
      response.should redirect_to(projects_url)
    end
  end
=end
end
