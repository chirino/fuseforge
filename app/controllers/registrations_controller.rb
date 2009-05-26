class RegistrationsController < ApplicationController
  skip_before_filter :login_required
  skip_before_filter :set_return_to
  
  def new
    return_to = request.env['HTTP_REFERER'] if params[:clicked] == 'yes'
    redirect_to "#{FUSESOURCE_URL}/register?return_to=#{return_to}"
  end
end
