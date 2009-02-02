module AuthenticateSpecHelper
  def mock_site_admin
    @mock_site_admin ||= mock_model(User, :is_site_admin? => true)
  end
  
  def mock_project_administrator_for
    @mock_project_administrator_for ||= mock_model(User, :is_project_administrator_for? => true)
  end
  
  def mock_registered_user
    @mock_registered_user ||= mock_model(User, :is_registered_user? => true)
  end
  
  def do_action_with_site_admin(*args)
    User.stub!(:find_by_id).and_return(mock_site_admin)

    get_args = args << { :last_crowd_check => Time.now, :user_id => 1 }
    send *get_args
  end  

  def do_action_with_project_administrator_for(*args)
    User.stub!(:find_by_id).and_return(mock_project_administrator_for)

    get_args = args << { :last_crowd_check => Time.now, :user_id => 1 }
    send *get_args
  end  

  # opts[:exclude] contains an array of actions to skip
  # opts[:include] contains an array of actions to add to the test in addition to any found by get_all_actions

  # test actions fail if not logged in
  def controller_actions_should_fail_if_not_logged_in(opts={})
    controller.stub!(:current_user).and_return(false)
    get_actions_to_test(opts).each { |a| test_failing_action(a, 'http://test.host/session/new') }
  end

  # test actions fail if not site admin
  def controller_actions_should_fail_if_not_site_admin(opts={})
    User.stub!(:find_by_id).and_return(mock_model(User, :is_site_admin? => false))
    get_actions_to_test(opts).each { |a| test_failing_action(a, 'http://test.host/', :last_crowd_check => Time.now, :user_id => 1) }
  end

  # test actions fail if not an administrator of the project
  def controller_actions_should_fail_if_not_project_administrator_for(opts={})
    User.stub!(:find_by_id).and_return(mock_model(User, :is_project_administrator_for? => false))
    get_actions_to_test(opts).each { |a| test_failing_action(a, 'http://test.host/', :last_crowd_check => Time.now, :user_id => 1) }
  end

  # get all actions for controller
  def get_all_actions
    controller.class.public_instance_methods(false).reject{ |action| ['rescue_action'].include?(action) }
  end
  
  # get actions to test for controller
  def get_actions_to_test(opts)
    except = opts[:except] || []
    actions_to_test = get_all_actions.reject{ |a| except.include?(a) }
    actions_to_test += opts[:include] if opts[:include]
    actions_to_test
  end

  def test_failing_action(a, redirect_url, session_values={})
    puts "... #{a}"
    get a, {}, session_values
    response.should_not be_success
    response.should redirect_to(redirect_url)
    flash[:warning].should == (defined?(@login_warning) ? @login_warning : nil)
  end
end

