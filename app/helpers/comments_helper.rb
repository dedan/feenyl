module CommentsHelper

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

  
end

