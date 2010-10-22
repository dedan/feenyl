
xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Feenyl Comments"
    xml.description "All Feenyl Comments"
#    xml.link formatted_articles_url(:rss)
    
    for comment in @comments
      xml.item do
        xml.title "#{comment.user.login} commented on #{comment.post.user.login}'s: #{comment.post.song}"
        xml.description comment.comment_text
        xml.pubDate comment.created_at.to_s(:rfc822)
        xml.link comment_url(comment.post)
        xml.guid "#{comment_url(comment.post)}/#{comment.id}"
      end
    end
  end
end