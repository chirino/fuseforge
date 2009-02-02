require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/issue_trackers/new.html.erb" do
  include IssueTrackersHelper
  
  before(:each) do
    assigns[:issue_tracker] = stub_model(IssueTracker,
      :new_record? => true,
      :active => false,
      :use_internal => false,
      :external_url => "value for external_url"
    )
  end

  it "should render new form" do
    render "/issue_trackers/new.html.erb"
    
    response.should have_tag("form[action=?][method=post]", issue_trackers_path) do
      with_tag("input#issue_tracker_active[name=?]", "issue_tracker[active]")
      with_tag("input#issue_tracker_use_internal[name=?]", "issue_tracker[use_internal]")
      with_tag("input#issue_tracker_external_url[name=?]", "issue_tracker[external_url]")
    end
  end
end


