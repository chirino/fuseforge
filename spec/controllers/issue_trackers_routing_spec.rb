require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe IssueTrackersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "issue_trackers", :action => "index").should == "/issue_trackers"
    end
  
    it "should map #new" do
      route_for(:controller => "issue_trackers", :action => "new").should == "/issue_trackers/new"
    end
  
    it "should map #show" do
      route_for(:controller => "issue_trackers", :action => "show", :id => 1).should == "/issue_trackers/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "issue_trackers", :action => "edit", :id => 1).should == "/issue_trackers/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "issue_trackers", :action => "update", :id => 1).should == "/issue_trackers/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "issue_trackers", :action => "destroy", :id => 1).should == "/issue_trackers/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/issue_trackers").should == {:controller => "issue_trackers", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/issue_trackers/new").should == {:controller => "issue_trackers", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/issue_trackers").should == {:controller => "issue_trackers", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/issue_trackers/1").should == {:controller => "issue_trackers", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/issue_trackers/1/edit").should == {:controller => "issue_trackers", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/issue_trackers/1").should == {:controller => "issue_trackers", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/issue_trackers/1").should == {:controller => "issue_trackers", :action => "destroy", :id => "1"}
    end
  end
end
