ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.smtp_settings = {
    :address => "smtp.domain.de",
    :port => 25,
    :domain => "www.domain.de",
    :authentication => :login,
    :user_name => "benutzername",
    :password => "passwort"
}