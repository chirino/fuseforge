class SessionsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :set_return_to
  
  def new
    redirect_to "#{FUSESOURCE_URL}/login?return_to=#{session[:return_to]}"
  end

  def destroy
    reset_session
    redirect_to "#{FUSESOURCE_URL}/logout?return_to=#{FUSEFORGE_URL}"
  end
end
