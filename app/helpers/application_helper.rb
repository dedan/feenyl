# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def submit_button_tag text, image_url
    "<button name=\"submit\" type=\"submit\"><p>#{image_tag(image_url)}<br/>#{text}</p></button>"
  end
  
  def submit_button_tag_float text, image_url, float
    "<div style=\"float:#{float};\"><button name=\"submit\" type=\"submit\"><p>#{image_tag(image_url)}<br/>#{text}</p></button></div>"
  end
  
  def reset_button_tag text, image_url
    "<button name=\"reset\" type=\"reset\"><p>#{image_tag(image_url)}<br/>#{text}</p></button>"
  end
  
    def to_word (i)
    case i 
    when 1
      return "one"
    when 2
      "two"
    when 3
      "three"
    when 4
      "four"
    when 5
      "five"
    when 6
      "six"
    when 7
      "seven"
    when 8
      "eight"
    when 9
      "nine"
    when 10
      "ten"

    end
  end

  
end
