require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProjectCategoriesController do

  def mock_project_category(stubs={})
    @mock_project_category ||= mock_model(ProjectCategory, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all project_categories as @project_categories" do
      ProjectCategory.should_receive(:find).with(:all).and_return([mock_project_category])
      get :index
      assigns[:project_categories].should == [mock_project_category]
    end

    describe "with mime type of xml" do
  
      it "should render all project_categories as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProjectCategory.should_receive(:find).with(:all).and_return(project_categories = mock("Array of ProjectCategories"))
        project_categories.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested project_category as @project_category" do
      ProjectCategory.should_receive(:find).with("37").and_return(mock_project_category)
      get :show, :id => "37"
      assigns[:project_category].should equal(mock_project_category)
    end
    
    describe "with mime type of xml" do

      it "should render the requested project_category as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProjectCategory.should_receive(:find).with("37").and_return(mock_project_category)
        mock_project_category.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new project_category as @project_category" do
      ProjectCategory.should_receive(:new).and_return(mock_project_category)
      get :new
      assigns[:project_category].should equal(mock_project_category)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested project_category as @project_category" do
      ProjectCategory.should_receive(:find).with("37").and_return(mock_project_category)
      get :edit, :id => "37"
      assigns[:project_category].should equal(mock_project_category)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created project_category as @project_category" do
        ProjectCategory.should_receive(:new).with({'these' => 'params'}).and_return(mock_project_category(:save => true))
        post :create, :project_category => {:these => 'params'}
        assigns(:project_category).should equal(mock_project_category)
      end

      it "should redirect to the created project_category" do
        ProjectCategory.stub!(:new).and_return(mock_project_category(:save => true))
        post :create, :project_category => {}
        response.should redirect_to(project_category_url(mock_project_category))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved project_category as @project_category" do
        ProjectCategory.stub!(:new).with({'these' => 'params'}).and_return(mock_project_category(:save => false))
        post :create, :project_category => {:these => 'params'}
        assigns(:project_category).should equal(mock_project_category)
      end

      it "should re-render the 'new' template" do
        ProjectCategory.stub!(:new).and_return(mock_project_category(:save => false))
        post :create, :project_category => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested project_category" do
        ProjectCategory.should_receive(:find).with("37").and_return(mock_project_category)
        mock_project_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :project_category => {:these => 'params'}
      end

      it "should expose the requested project_category as @project_category" do
        ProjectCategory.stub!(:find).and_return(mock_project_category(:update_attributes => true))
        put :update, :id => "1"
        assigns(:project_category).should equal(mock_project_category)
      end

      it "should redirect to the project_category" do
        ProjectCategory.stub!(:find).and_return(mock_project_category(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(project_category_url(mock_project_category))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested project_category" do
        ProjectCategory.should_receive(:find).with("37").and_return(mock_project_category)
        mock_project_category.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :project_category => {:these => 'params'}
      end

      it "should expose the project_category as @project_category" do
        ProjectCategory.stub!(:find).and_return(mock_project_category(:update_attributes => false))
        put :update, :id => "1"
        assigns(:project_category).should equal(mock_project_category)
      end

      it "should re-render the 'edit' template" do
        ProjectCategory.stub!(:find).and_return(mock_project_category(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested project_category" do
      ProjectCategory.should_receive(:find).with("37").and_return(mock_project_category)
      mock_project_category.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the project_categories list" do
      ProjectCategory.stub!(:find).and_return(mock_project_category(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(project_categories_url)
    end

  end

end
