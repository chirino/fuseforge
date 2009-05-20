class AdminController < ApplicationController
  allow :user => :is_site_admin?

  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
end