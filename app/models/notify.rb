class Notify < ActionMailer::Base
  default :from => "feenyl@wrfl.de"

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
    @recipients = "#{EMAIL}, #{user.email}"
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
    @recipients = "#{EMAIL}, #{user.email}"
    @from       = EMAIL
    @sent_on    = Time.now
  end

end
