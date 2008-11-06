class InitiatorMailer < ActionMailer::Base
  
  def mail(user, organisation)
    @recipients  = "info@demowatch.eu"
    @from        = "#{user.email}"
    @subject     = "[www.demowatch.eu] new Initiator"
    @sent_on     = Time.now
    @body[:user] = user
    @body[:organisation] = organisation
  end  

end
