require File.expand_path(File.dirname(__FILE__) + '/../../spec_helper')

describe "/issue_trackers/index.html.erb" do
  include IssueTrackersHelper
  
  before(:each) do
    assigns[:issue_trackers] = [
      stub_model(IssueTracker,
        :active => false,
        :use_internal => false,
        :external_url => "value for external_url"
      ),
      stub_model(IssueTracker,
        :active => false,
        :use_internal => false,
        :external_url => "value for external_url"
      )
    ]
  end

  it "should render list of issue_trackers" do
    render "/issue_trackers/index.html.erb"
    response.should have_tag("tr>td", false, 2)
    response.should have_tag("tr>td", false, 2)
    response.should have_tag("tr>td", "value for external_url", 2)
  end
end

