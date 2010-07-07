module UsersHelper
  
  def no_space?
	 User.find(:all).size > MAX_USERS
  end
  
end