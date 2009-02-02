require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/issue_trackers/show.html.erb" do
  include IssueTrackersHelper
  
  before(:each) do
    assigns[:issue_tracker] = @issue_tracker = stub_model(IssueTracker,
      :active => false,
      :use_internal => false,
      :external_url => "value for external_url"
    )
  end

  it "should render attributes in <p>" do
    render "/issue_trackers/show.html.erb"
    response.should have_text(/als/)
    response.should have_text(/als/)
    response.should have_text(/value\ for\ external_url/)
  end
end

