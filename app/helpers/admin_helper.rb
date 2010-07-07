module AdminHelper
  
  def authorized?
      current_user.login == "admin"
  end
  
end
