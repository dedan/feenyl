module MusicHelper
      
  def user_may_post?
    # stellt fest ob der aktuelle benutzer berechtigt ist zu posten
    days_since_last_post >= DAYS_TO_WAIT && current_user.activated
  end
  
  def days_since_last_post
    # gibt die anzahl der tage seit dem letzten post des akt. benutzers zurück
    return 100 if current_user.last_post.nil?
    (Date.today - current_user.last_post).to_i
  end
  
  def image_link image_url, text, target, css_class
    "<a href=\"#{target}\"><div class=\"#{css_class}\">#{image_tag(image_url)}<br/>#{text}</div></a>"
  end
  
  
  def limit_to number, string
    if string.length > number
      return string[0..number] + ".."
    end
      string
  end
  


end
