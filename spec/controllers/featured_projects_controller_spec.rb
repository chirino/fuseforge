require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')
require File.expand_path(File.dirname(__FILE__) + '/../spec_controller_helper')

describe FeaturedProjectsController do
  include AuthenticateSpecHelper
  
  def mock_featured_project(stubs={})
    @mock_featured_project ||= mock_model(FeaturedProject, stubs)
  end
  
  describe "when user" do
    describe "not logged in" do
      it "all actions should fail" do
        controller_actions_should_fail_if_not_logged_in
      end  
    end
  
    describe "not a site administrator" do
      it "all actions should fail" do
        controller_actions_should_fail_if_not_site_admin
      end  
    end
  end
  
  describe "responding to GET index" do
    it "should expose all featured_projects as @featured_projects" do
      FeaturedProject.should_receive(:all).and_return([mock_featured_project])
      do_action_with_site_admin :get, :index, {} 
      assigns[:featured_projects].should == [mock_featured_project]
    end

    it "should render index template'" do
      do_action_with_site_admin :get, :index, {} 
      response.should render_template(:index)
    end
  end

  describe "responding to GET new" do
    it "should expose a new featured_project as @featured_project" do
      FeaturedProject.should_receive(:new).and_return(mock_featured_project)
      do_action_with_site_admin :get, :new, {}
      assigns[:featured_project].should equal(mock_featured_project)
    end

    it "should render new template'" do
      do_action_with_site_admin :get, :new, {} 
      response.should render_template(:new)
    end
  end

  describe "responding to GET edit" do
    before(:each) do
      FeaturedProject.stub!(:find).and_return(mock_featured_project)
    end
    
    it "should expose the requested featured_project as @featured_project" do
      FeaturedProject.should_receive(:find).with("37").and_return(mock_featured_project)
      do_action_with_site_admin :get, :edit, { :id => "37" } 
      assigns[:featured_project].should equal(mock_featured_project)
    end

    it "should render edit template'" do
      do_action_with_site_admin :get, :edit, { :id => "37" } 
      response.should render_template(:edit)
    end
  end

  describe "responding to POST create" do
    describe "with valid params" do
      it "should expose a newly created featured_project as @featured_project" do
        FeaturedProject.should_receive(:new).with({'these' => 'params'}).and_return(mock_featured_project(:save => true))
        do_action_with_site_admin :post, :create, { :featured_project => { :these => 'params' } }
        assigns(:featured_project).should equal(mock_featured_project)
      end

      it "should redirect to the list of featured projects" do
        FeaturedProject.stub!(:new).and_return(mock_featured_project(:save => true))
        do_action_with_site_admin :post, :create, { :featured_project => {} }
        response.should redirect_to(featured_projects_url)
      end

    end
    
    describe "with invalid params" do
      it "should expose a newly created but unsaved featured_project as @featured_project" do
        FeaturedProject.stub!(:new).with({'these' => 'params'}).and_return(mock_featured_project(:save => false))
        do_action_with_site_admin :post, :create, { :featured_project => { :these => 'params' } }
        assigns(:featured_project).should equal(mock_featured_project)
      end

      it "should re-render the 'new' template" do
        FeaturedProject.stub!(:new).and_return(mock_featured_project(:save => false))
        do_action_with_site_admin :post, :create, { :featured_project => {} }
        response.should render_template('new')
      end
    end
  end

  describe "responding to PUT udpate" do
    describe "with valid params" do
      it "should update the requested featured_project" do
        FeaturedProject.should_receive(:find).with("37").and_return(mock_featured_project(:save => true))
        mock_featured_project.should_receive(:position=).with('2')
        do_action_with_site_admin :put, :update, { :id => "37", :featured_project => {:position => '2'} }
      end

      it "should expose the requested featured_project as @featured_project" do
        FeaturedProject.stub!(:find).and_return(mock_featured_project(:save => true, :position= => true))
        do_action_with_site_admin :put, :update, { :id => "37", :featured_project => {:position => '2'} }
        assigns(:featured_project).should equal(mock_featured_project)
      end

      it "should redirect to the featured_project" do
        FeaturedProject.stub!(:find).and_return(mock_featured_project(:save => true, :position= => true))
         do_action_with_site_admin :put, :update, { :id => "37", :featured_project => {:position => '2'} }
        response.should redirect_to(featured_projects_url)
      end
    end
    
    describe "with invalid params" do
      it "should update the requested featured_project" do
        FeaturedProject.should_receive(:find).with("37").and_return(mock_featured_project(:save => true))
        mock_featured_project.should_receive(:position=).with('2')
        do_action_with_site_admin :put, :update, { :id => "37", :featured_project => {:position => '2'} }
      end

      it "should expose the featured_project as @featured_project" do
        FeaturedProject.stub!(:find).and_return(mock_featured_project(:save => true, :position= => true))
        do_action_with_site_admin :put, :update, { :id => "37", :featured_project => {:position => '2'} }
        assigns(:featured_project).should equal(mock_featured_project)
      end

      it "should re-render the 'edit' template" do
        FeaturedProject.stub!(:find).and_return(mock_featured_project(:save => false, :position= => true))
        do_action_with_site_admin :put, :update, { :id => "37", :featured_project => {:position => '2'} }
        response.should render_template('edit')
      end
    end
  end

  describe "responding to DELETE destroy" do
    it "should destroy the requested featured_project" do
      FeaturedProject.should_receive(:find).with("37").and_return(mock_featured_project)
      mock_featured_project.should_receive(:destroy)
      do_action_with_site_admin :delete, :destroy, { :id => "37" }
    end
  
    it "should redirect to the featured_projects list" do
      FeaturedProject.stub!(:find).and_return(mock_featured_project(:destroy => true))
      do_action_with_site_admin :delete, :destroy, { :id => "37" }
      response.should redirect_to(featured_projects_url)
    end
  end
end
