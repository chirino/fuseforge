class UsersController < ApplicationController
  layout "new_look"

  before_filter :get_user, :only => [:edit, :update]
  allow :edit, :update, :exec => :can_update?

  def edit_self
    @user = @current_user
    respond_to do |format|
      format.html { render :action => "edit" }
      format.xml  { render :xml => @user }
    end
  end
  
  def update
    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User Profile Was successfully updated.'
        format.html { redirect_to :controller => 'homepage' }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @news_item.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  private
  
  def get_user
    @user = User.find(params[:id])
  end
  
  def can_update?
    # Site admin and update any user
    return true if @current_user.is_site_admin?
    # The current user can only update his own profile.
    return @current_user.login == params[:id]
  end
  
end
