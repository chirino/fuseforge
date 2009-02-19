class SessionsController < ApplicationController
  skip_before_filter :login_required

  def new
    # send user to FUSESource login
    cookies[REDIRECT_BACK_COOKIE_NAME] = { :value => FUSEFORGE_URL + (session[:return_to].nil? ? '' : session[:return_to]), 
     :domain => REDIRECT_BACK_COOKIE_DOMAIN_NAME }
    redirect_to "#{FUSESOURCE_URL}login"
  end

  def destroy
    reset_session

    # send user to FUSESource logout
    cookies[REDIRECT_BACK_COOKIE_NAME] = { :value => FUSEFORGE_URL, :domain => REDIRECT_BACK_COOKIE_DOMAIN_NAME } 
    redirect_to "#{FUSESOURCE_URL}logout"
  end
end
