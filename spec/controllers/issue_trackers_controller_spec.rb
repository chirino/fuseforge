require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IssueTrackersController do

  def mock_issue_tracker(stubs={})
    @mock_issue_tracker ||= mock_model(IssueTracker, stubs)
  end
  
  describe "responding to GET index" do

    it "should expose all issue_trackers as @issue_trackers" do
      IssueTracker.should_receive(:find).with(:all).and_return([mock_issue_tracker])
      get :index
      assigns[:issue_trackers].should == [mock_issue_tracker]
    end

    describe "with mime type of xml" do
  
      it "should render all issue_trackers as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        IssueTracker.should_receive(:find).with(:all).and_return(issue_trackers = mock("Array of IssueTrackers"))
        issue_trackers.should_receive(:to_xml).and_return("generated XML")
        get :index
        response.body.should == "generated XML"
      end
    
    end

  end

  describe "responding to GET show" do

    it "should expose the requested issue_tracker as @issue_tracker" do
      IssueTracker.should_receive(:find).with("37").and_return(mock_issue_tracker)
      get :show, :id => "37"
      assigns[:issue_tracker].should equal(mock_issue_tracker)
    end
    
    describe "with mime type of xml" do

      it "should render the requested issue_tracker as xml" do
        request.env["HTTP_ACCEPT"] = "application/xml"
        IssueTracker.should_receive(:find).with("37").and_return(mock_issue_tracker)
        mock_issue_tracker.should_receive(:to_xml).and_return("generated XML")
        get :show, :id => "37"
        response.body.should == "generated XML"
      end

    end
    
  end

  describe "responding to GET new" do
  
    it "should expose a new issue_tracker as @issue_tracker" do
      IssueTracker.should_receive(:new).and_return(mock_issue_tracker)
      get :new
      assigns[:issue_tracker].should equal(mock_issue_tracker)
    end

  end

  describe "responding to GET edit" do
  
    it "should expose the requested issue_tracker as @issue_tracker" do
      IssueTracker.should_receive(:find).with("37").and_return(mock_issue_tracker)
      get :edit, :id => "37"
      assigns[:issue_tracker].should equal(mock_issue_tracker)
    end

  end

  describe "responding to POST create" do

    describe "with valid params" do
      
      it "should expose a newly created issue_tracker as @issue_tracker" do
        IssueTracker.should_receive(:new).with({'these' => 'params'}).and_return(mock_issue_tracker(:save => true))
        post :create, :issue_tracker => {:these => 'params'}
        assigns(:issue_tracker).should equal(mock_issue_tracker)
      end

      it "should redirect to the created issue_tracker" do
        IssueTracker.stub!(:new).and_return(mock_issue_tracker(:save => true))
        post :create, :issue_tracker => {}
        response.should redirect_to(issue_tracker_url(mock_issue_tracker))
      end
      
    end
    
    describe "with invalid params" do

      it "should expose a newly created but unsaved issue_tracker as @issue_tracker" do
        IssueTracker.stub!(:new).with({'these' => 'params'}).and_return(mock_issue_tracker(:save => false))
        post :create, :issue_tracker => {:these => 'params'}
        assigns(:issue_tracker).should equal(mock_issue_tracker)
      end

      it "should re-render the 'new' template" do
        IssueTracker.stub!(:new).and_return(mock_issue_tracker(:save => false))
        post :create, :issue_tracker => {}
        response.should render_template('new')
      end
      
    end
    
  end

  describe "responding to PUT udpate" do

    describe "with valid params" do

      it "should update the requested issue_tracker" do
        IssueTracker.should_receive(:find).with("37").and_return(mock_issue_tracker)
        mock_issue_tracker.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :issue_tracker => {:these => 'params'}
      end

      it "should expose the requested issue_tracker as @issue_tracker" do
        IssueTracker.stub!(:find).and_return(mock_issue_tracker(:update_attributes => true))
        put :update, :id => "1"
        assigns(:issue_tracker).should equal(mock_issue_tracker)
      end

      it "should redirect to the issue_tracker" do
        IssueTracker.stub!(:find).and_return(mock_issue_tracker(:update_attributes => true))
        put :update, :id => "1"
        response.should redirect_to(issue_tracker_url(mock_issue_tracker))
      end

    end
    
    describe "with invalid params" do

      it "should update the requested issue_tracker" do
        IssueTracker.should_receive(:find).with("37").and_return(mock_issue_tracker)
        mock_issue_tracker.should_receive(:update_attributes).with({'these' => 'params'})
        put :update, :id => "37", :issue_tracker => {:these => 'params'}
      end

      it "should expose the issue_tracker as @issue_tracker" do
        IssueTracker.stub!(:find).and_return(mock_issue_tracker(:update_attributes => false))
        put :update, :id => "1"
        assigns(:issue_tracker).should equal(mock_issue_tracker)
      end

      it "should re-render the 'edit' template" do
        IssueTracker.stub!(:find).and_return(mock_issue_tracker(:update_attributes => false))
        put :update, :id => "1"
        response.should render_template('edit')
      end

    end

  end

  describe "responding to DELETE destroy" do

    it "should destroy the requested issue_tracker" do
      IssueTracker.should_receive(:find).with("37").and_return(mock_issue_tracker)
      mock_issue_tracker.should_receive(:destroy)
      delete :destroy, :id => "37"
    end
  
    it "should redirect to the issue_trackers list" do
      IssueTracker.stub!(:find).and_return(mock_issue_tracker(:destroy => true))
      delete :destroy, :id => "1"
      response.should redirect_to(issue_trackers_url)
    end

  end

end
