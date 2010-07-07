# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  # include AuthenticatedSystem
  layout "music"

  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      current_user.delete_unposted_file
		
      # redirect admin to admin page
      if current_user.is_admin?
        redirect_back_or_default("/admin")
      else
        redirect_back_or_default('/music')
      end
      flash[:notice] = "Logged in successfully"
    else
      flash[:notice] = "Username or Password wrong !"
      render :action => 'new'
    end
  end

  def destroy
    current_user.delete_unposted_file
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default('/music')
  end
  
  
  
  
end
