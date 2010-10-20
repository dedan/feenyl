class Notify < ActionMailer::Base

  def signup(user)
    @subject    = 'Feenyl Signup'
    @body       = {:user => user}
    @recipients = "#{EMAIL}, #{user.email}"
    @from       = EMAIL
    @sent_on    = Time.now
  end
  
  def activated(user, activator)
    @subject    = 'Feenyl Activation'
    @body       = {:user => user, :activator => activator}
    @recipients = "#{EMAIL}, #{user.email}"
    @from       = EMAIL
    @sent_on    = Time.now	 
  end

  def remember(user)
    @subject    = 'Don\'t forget Feenyl'
    @body       = {:user => user}
    @recipients = user.email
    @from       = EMAIL
    @sent_on    = Time.now
  end
  
  def deleted(user)
    @subject    = 'Feenyl: You have been deleted'
    @body       = {:user => user}
    @recipients = "#{EMAIL}, #{user.email}"
    @from       = EMAIL
    @sent_on    = Time.now
  end
  
  def weekly_reminder(user)
    @subject    = 'Yeah, you are allowed to post again'
    @body       = {:user => user}
    @recipients = user.email
    @from       = EMAIL
    @sent_on    = Time.now
  end
  
  def notify_poster(comment)
    @subject    = "#{comment.user.login} wrote a comment to your post"
    @body       = {:comment => comment}
    @recipients = comment.post.user.email
    @from       = EMAIL
    @sent_on    = Time.now
  end
  
  def notify_commenter(comment, commenter)
    @subject    = "#{comment.user.login} wrote a comment to a post you commented"
    @body       = {:comment => comment, :commenter => commenter}
    @recipients = commenter.email
    @from       = EMAIL
    @sent_on    = Time.now
  end
  
  def mail_to_all(user, text, subj)
    @subject    = subj
    @body       = {:user => user, :text => text}
    @recipients = user.email
    @from       = EMAIL
    @sent_on    = Time.now
  end

end
