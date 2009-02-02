require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProspectiveProjectMembersController do

  def mock_prospective_project_member(stubs={})
    @mock_prospective_project_member ||= mock_model(ProspectiveProjectMember, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all prospective_project_members as @prospective_project_members" do
      ProspectiveProjectMember.should_receive(:find).with(:all).and_return([mock_prospective_project_member])
      get :index
      assigns[:prospective_project_members].should == [mock_prospective_project_member]
    end

    describe "with mime type of xml" do
  
      it "should render all prospective_project_members as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProspectiveProjectMember.should_receive(:find).with(:all).and_return(prospective_project_members = mock("Array of ProspectiveProjectMembers"))
        prospective_project_members.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested prospective_project_member as @prospective_project_member" do
      ProspectiveProjectMember.should_receive(:find).with("37").and_return(mock_prospective_project_member)
      get :show, :id => "37"
      assigns[:prospective_project_member].should equal(mock_prospective_project_member)
    end
    
    describe "with mime type of xml" do

      it "should render the requested prospective_project_member as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        ProspectiveProjectMember.should_receive(:find).with("37").and_return(mock_prospective_project_member)
        mock_prospective_project_member.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new prospective_project_member as @prospective_project_member" do
      ProspectiveProjectMember.should_receive(:new).and_return(mock_prospective_project_member)
      get :new
      assigns[:prospective_project_member].should equal(mock_prospective_project_member)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested prospective_project_member as @prospective_project_member" do
      ProspectiveProjectMember.should_receive(:find).with("37").and_return(mock_prospective_project_member)
      get :edit, :id => "37"
      assigns[:prospective_project_member].should equal(mock_prospective_project_member)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created prospective_project_member as @prospective_project_member" do
        ProspectiveProjectMember.should_receive(:new).with({'these' => 'params'}).and_return(mock_prospective_project_member(:save => true))
        post :create, :prospective_project_member => {:these => 'params'}
        assigns(:prospective_project_member).should equal(mock_prospective_project_member)
      end

      it "should redirect to the created prospective_project_member" do
        ProspectiveProjectMember.stub!(:new).and_return(mock_prospective_project_member(:save => true))
        post :create, :prospective_project_member => {}
        response.should redirect_to(prospective_project_member_url(mock_prospective_project_member))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved prospective_project_member as @prospective_project_member" do
        ProspectiveProjectMember.stub!(:new).with({'these' => 'params'}).and_return(mock_prospective_project_member(:save => false))
        post :create, :prospective_project_member => {:these => 'params'}
        assigns(:prospective_project_member).should equal(mock_prospective_project_member)
      end

      it "should re-render the 'new' template" do
        ProspectiveProjectMember.stub!(:new).and_return(mock_prospective_project_member(:save => false))
        post :create, :prospective_project_member => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested prospective_project_member" do
        ProspectiveProjectMember.should_receive(:find).with("37").and_return(mock_prospective_project_member)
        mock_prospective_project_member.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :prospective_project_member => {:these => 'params'}
      end

      it "should expose the requested prospective_project_member as @prospective_project_member" do
        ProspectiveProjectMember.stub!(:find).and_return(mock_prospective_project_member(:update_attributes => true))
        put :update, :id => "1"
        assigns(:prospective_project_member).should equal(mock_prospective_project_member)
      end

      it "should redirect to the prospective_project_member" do
        ProspectiveProjectMember.stub!(:find).and_return(mock_prospective_project_member(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(prospective_project_member_url(mock_prospective_project_member))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested prospective_project_member" do
        ProspectiveProjectMember.should_receive(:find).with("37").and_return(mock_prospective_project_member)
        mock_prospective_project_member.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :prospective_project_member => {:these => 'params'}
      end

      it "should expose the prospective_project_member as @prospective_project_member" do
        ProspectiveProjectMember.stub!(:find).and_return(mock_prospective_project_member(:update_attributes => false))
        put :update, :id => "1"
        assigns(:prospective_project_member).should equal(mock_prospective_project_member)
      end

      it "should re-render the 'edit' template" do
        ProspectiveProjectMember.stub!(:find).and_return(mock_prospective_project_member(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested prospective_project_member" do
      ProspectiveProjectMember.should_receive(:find).with("37").and_return(mock_prospective_project_member)
      mock_prospective_project_member.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the prospective_project_members list" do
      ProspectiveProjectMember.stub!(:find).and_return(mock_prospective_project_member(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(prospective_project_members_url)
    end

  end

end
