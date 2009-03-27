class RegistrationsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :set_return_to
  
  def new
    redirect_to "#{FUSESOURCE_URL}/register?return_to=#{session[:return_to]}"
  end
end
