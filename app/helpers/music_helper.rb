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

  def insert_hyperlinks_and_br string, css_class
    if string != nil
      string.gsub!(/(http|https):\/\/[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.([a-z]{2,5})(([0-9]{1,5})?\/\S*)?/i,
						  "<a class=\"#{css_class}\" target=\"_blank\" href=\"\\0\">\\0</a>")
      string.gsub!(/\n/, "<br/>")
      string.gsub!(/:-\(/, image_tag("Frown.png"))
      string.gsub!(/:-\)/, image_tag("Smile.png"))
      string.gsub!(/:-P/, image_tag("sticking.png"))
      string.gsub!(/:-\//, image_tag("Undecided.png"))
      string.gsub!(/;-\)/, image_tag("Wink.png"))
      string.gsub!(/:-D/, image_tag("Grin.png"))
      string.gsub!(/\*rock\*/, image_tag("rock.gif"))
      string.gsub!(/\*smoker\*/, image_tag("smoker.gif"))
      string.gsub!(/\*afro\*/, image_tag("afro.gif"))
    end
    string
  end
  
  
  def limit_to number, string
    if string.length > number
      return string[0..number] + ".."
    end
      string
  end
  


end
