class RegistrationsController < ApplicationController
  skip_before_filter :login_required
  
  def new
    redirect_to "#{FUSESOURCE_URL}/register?return_to=#{session[:return_to]}"
  end
  private
  
  def set_return_to
    session[:return_to] = request.env['HTTP_REFERER'] if request.env['HTTP_REFERER'] =~ /[/forum|/wiki]/
  end
end
