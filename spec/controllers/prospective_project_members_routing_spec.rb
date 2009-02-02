require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe ProspectiveProjectMembersController do
  describe "route generation" do
    it "should map #index" do
      route_for(:controller => "prospective_project_members", :action => "index").should == "/prospective_project_members"
    end
  
    it "should map #new" do
      route_for(:controller => "prospective_project_members", :action => "new").should == "/prospective_project_members/new"
    end
  
    it "should map #show" do
      route_for(:controller => "prospective_project_members", :action => "show", :id => 1).should == "/prospective_project_members/1"
    end
  
    it "should map #edit" do
      route_for(:controller => "prospective_project_members", :action => "edit", :id => 1).should == "/prospective_project_members/1/edit"
    end
  
    it "should map #update" do
      route_for(:controller => "prospective_project_members", :action => "update", :id => 1).should == "/prospective_project_members/1"
    end
  
    it "should map #destroy" do
      route_for(:controller => "prospective_project_members", :action => "destroy", :id => 1).should == "/prospective_project_members/1"
    end
  end

  describe "route recognition" do
    it "should generate params for #index" do
      params_from(:get, "/prospective_project_members").should == {:controller => "prospective_project_members", :action => "index"}
    end
  
    it "should generate params for #new" do
      params_from(:get, "/prospective_project_members/new").should == {:controller => "prospective_project_members", :action => "new"}
    end
  
    it "should generate params for #create" do
      params_from(:post, "/prospective_project_members").should == {:controller => "prospective_project_members", :action => "create"}
    end
  
    it "should generate params for #show" do
      params_from(:get, "/prospective_project_members/1").should == {:controller => "prospective_project_members", :action => "show", :id => "1"}
    end
  
    it "should generate params for #edit" do
      params_from(:get, "/prospective_project_members/1/edit").should == {:controller => "prospective_project_members", :action => "edit", :id => "1"}
    end
  
    it "should generate params for #update" do
      params_from(:put, "/prospective_project_members/1").should == {:controller => "prospective_project_members", :action => "update", :id => "1"}
    end
  
    it "should generate params for #destroy" do
      params_from(:delete, "/prospective_project_members/1").should == {:controller => "prospective_project_members", :action => "destroy", :id => "1"}
    end
  end
end
