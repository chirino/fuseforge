require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class Project
  def approve
    IssuesProject.should_receive(:exists?).with('TESTPROJECT').and_return(true)
    ProjectForum.should_receive(:exists?).with('TESTPROJECT').and_return(true)
    WikiSpace.should_receive(:exists?).with('TESTPROJECT').and_return(true)
    ProjectRepository.should_receive(:exists?).with('TESTPROJECT').and_return(true)

    self.status = ProjectStatus.active
    self.save
  end  
end


describe Project do
  before(:each) do
    @valid_attributes = {
      :name => "value for name",
      :shortname => "SHORTNAME",
      :description => "value for description",
      :project_maturity_id => 1
    }
    UserActionObserver.current_user = User.find(1)    
    @user_action_obs = UserActionObserver.instance
  end
  
  describe " when returning recent projects" do
    it "should return a list of projects" do
      Project.recent.should_not be_empty
    end
    
    it "should return approved projects" do
      Project.recent.should include(projects(:one))
    end
      
    it "should not return unapproved projects" do
      Project.recent.should_not include(projects(:three))
    end
  end
  
  describe " when first created" do
    it "should create a new instance given valid attributes" do
      project = Project.new(@valid_attributes)
      @user_action_obs.before_create(project)
      @user_action_obs.before_save(project)
      project.save!
    end
  
    it "should have a name" do
      project = Project.create
      project.should have(1).error_on(:name)

      project = Project.create(:name => 'Project Ninety Nine')
      project.should have(:no).errors_on(:name)
    end
  
    it "should have a unique name" do
      project = Project.create(:name => 'Project One')
      project.should have(1).error_on(:name)
    end
  
    it "should have a shortname" do
      project = Project.create
      project.should have(1).error_on(:shortname)
    end
  
    it "should have a valid shortname" do
      ['project one', 'Project One', 'project-one', 'project_one_!', 'project_one', 'projectone'].each do |shortname|
        project = Project.create(:shortname => shortname)
        project.should have(1).error_on(:shortname)
      end

      project = Project.create(:shortname => 'PROJECT99')
      project.should have(:no).errors_on(:shortname)
    end
  
    it "should have a unique shortname" do
      project = Project.create(:shortname => 'PROJECTONE')
      project.should have(1).error_on(:shortname)
    end

    it "should have a description" do
      project = Project.create
      project.should have(1).error_on(:description)

      project = Project.create(:description => 'This is a description')
      project.should have(:no).errors_on(:description)
    end
  
    it "should have an unapproved project status" do
      project = Project.create(@valid_attributes)
      project.status.should == ProjectStatus.unapproved
    end
  
    it "should have a maturity" do
      project = Project.create
      project.should have(1).error_on(:maturity)
    end
  
    it "should have a valid maturity" do
      project = Project.create(@valid_attributes.merge(:project_maturity_id => 99))
      project.should have(1).error_on(:maturity)
    
      project = Project.create(:project_maturity_id => 1)
      project.should have(:no).errors_on(:maturity)
    end

    it "should have a valid issues project URL" do
      projects(:one).issues_project.url.should == "#{BROWSE_ISSUES_URL}/#{projects(:one).shortname}"
    end

    it "should have a valid forum URL" do
      projects(:one).forum.url.should == "#{BROWSE_FORUM_URL}/#{projects(:one).shortname}/Home"
    end

    it "should have a valid wiki space URL" do
      projects(:one).wiki_space.url.should == "#{BROWSE_WIKI_URL}/#{projects(:one).shortname}/Home"
    end

    it "should have a valid repository URL" do
      projects(:one).repo.url.should == "#{BROWSE_REPO_URL}/#{projects(:one).shortname}"
    end

    it "should not create a new issues project, new project forum, new wiki space, new repo" do
      IssuesProject.exists?('TESTPROJECT').should be_false    
      ProjectForum.exists?('TESTPROJECT').should be_false    
      WikiSpace.exists?('TESTPROJECT').should be_false    
      ProjectRepository.exists?('TESTPROJECT').should be_false    

      project = Project.new(@valid_attributes)
      @user_action_obs.before_create(project)
      @user_action_obs.before_save(project)
      project.save

      IssuesProject.exists?('TESTPROJECT').should be_false
      ProjectForum.exists?('TESTPROJECT').should be_false  
      WikiSpace.exists?('TESTPROJECT').should be_false
      ProjectRepository.exists?('TESTPROJECT').should be_false    
    end
    
    it "should notify the site administrators"
  end

  describe " in regards to unapproved projects" do
    it "should return a list of projects" do
      Project.unapproved.should_not be_empty
    end
    
    it "should return only unapproved projects" do
      Project.unapproved.should include(projects(:three))
    end
      
    it "should not return approved projects" do
      Project.unapproved.should_not include(projects(:one))
    end
  end
  
  describe " when approved" do
    it "should create a new issues project, new project forum, new wiki space, new repo" do
      IssuesProject.exists?('TESTPROJECT').should be_false    
      ProjectForum.exists?('TESTPROJECT').should be_false    
      WikiSpace.exists?('TESTPROJECT').should be_false    
      ProjectRepository.exists?('TESTPROJECT').should be_false    

      project = Project.new(@valid_attributes)
      @user_action_obs.before_create(project)
      @user_action_obs.before_save(project)
      project.save
      project.approve

      IssuesProject.exists?('TESTPROJECT').should be_true
      ProjectForum.exists?('TESTPROJECT').should be_true    
      WikiSpace.exists?('TESTPROJECT').should be_true    
      ProjectRepository.exists?('TESTPROJECT').should be_true    
    end
    
    it "should notify the project administrator"
  end
  
  describe " when updating" do
    it "should not allow the shortname to be changed" do
      sn = projects(:one).shortname
      
      projects(:one).shortname = 'NEWSHORTNAME'
      projects(:one).shortname.should == sn
      
      projects(:one).update_attribute(:shortname, 'NEWSHORTNAME')
      projects(:one).save
      projects(:one).shortname.should == sn
    end
  end
end