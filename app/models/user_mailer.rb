class UserMailer < ActionMailer::Base
  def signup_notification(user)
    setup_email(user)
    @subject    += 'Bitte Dein Konto auf Demowatch.de aktivieren!'
  
    @body[:url]  = "http://www.demowatch.eu/activate/#{user.activation_code}"
  
  end
  
  def activation(user)
    setup_email(user)
    @subject    += 'Dein Konto auf Demowatch.de wurde aktiviert'
    @body[:url]  = "http://www.demowatch.eu/"
  end
  
  protected
    def setup_email(user)
      @recipients  = "#{user.email}"
      @from        = "no-reply@demowatch.eu"
      @subject     = "[www.demowatch.eu] "
      @sent_on     = Time.now
      @body[:user] = user
    end
end
