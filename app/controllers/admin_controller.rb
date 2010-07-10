class AdminController < ApplicationController

  layout "music"



  def index
    #redirect_to :action => "list_unauthorized_users"
  end


  def remind_users
   if params[:name] == "admin" and params[:pass] == "hugendubel"
   
    @users = User.find(:all, :conditions => "remind_me = true")
    @users.each do |user|  
      if (user.reminded == false) and 
        (!user.last_post.nil?) and
        (Date.today - user.last_post >= DAYS_TO_WAIT)
          Thread.new(user){|u| Notify.deliver_weekly_reminder(u)} 
          user.reminded = true
          user.save
      end   
    end
   end
  end
  
  # TODO check whether admin (has to work with crone job)
  def lazy_users
    @users = User.lazy_users
    Thread.new(@users) do |users|  
      users.each { |user| Notify.deliver_remember(user) }
    end
  end


  def delete_user
   user_to_delete = User.find(params[:id])
   flash[:notice] = "#{user_to_delete.login} deleted !"
   Thread.new(user_to_delete) { |actUser| Notify.deliver_deleted(actUser)  }
   user = User.find(params[:id]) 
    user.remove_digest
   user.delete_all_posted
   User.delete(params[:id])
   redirect_to :action => "index"
  end
  
  def authorize_users
    @activation = params["u"]
   @users    = []
   params["u"] = nil
   unless @activation.nil?
    @activation.each do |user| 
      tmp_user  = User.find(user[0])
      @users    << tmp_user

      if user[1]['activated'] == "1"

       #wenn noch nicht aktiviert, dann jetzt
       #und mach ihn zum htacces user
        if (tmp_user.activated == false)
          tmp_user.activated = 1
          tmp_user.make_htaccess_users
          tmp_user.save
          Thread.new(tmp_user) { |actUser|
            Notify.deliver_activated(actUser, current_user)
          }
        end
      end
    end
   else
    redirect_to :action => "list_users"
   end
  end
  
  def list_unauthorized_users 
    redirect_to :action => "list_users", :unauthorized => "yes"
  end
  
  def list_users    
    if params["unauthorized"] == "yes"
      @users = User.find(:all, :conditions => "activated = false") 
    else
      @users = User.find(:all)  
    end
  end
  
end
