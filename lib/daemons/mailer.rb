#!/usr/bin/env ruby



def send_mails_on_new_events
  # die demo ist neu und wurde zum letzten mal vor 2, 3 stunden geupdated
  events =  Event.find(:all, :conditions => ['new_delivered_at IS NULL AND updated_at < ?', 2.minutes.ago ]) 
  events.each do |event|
    User.find_by_event( event).each do |user| 
      EventMailer.deliver_new_event_of_interest( user, event)
      sleep 2 ## um nicht als spamversender eingestuft zu werden
    end
    event.new_delivered_at = Time.now
    event.save
    sleep 60
  end
end





# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  # Replace this with your code
  ActiveRecord::Base.logger.info "#{Time.now}: MailerDaemon: Checking for new mail delivery tasks.\n"

  send_mails_on_new_events
  
  ActiveRecord::Base.logger.info "#{Time.now}: MailerDaemon: Sleeping an hour.\n"
  sleep 3600

end



