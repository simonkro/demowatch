#!/usr/bin/env ruby

# You might want to change this
ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  
  # Replace this with your code
  ActiveRecord::Base.logger.info "This daemon is still running at #{Time.now}.\n"
  
  events =  Event.find(:all, :conditions => "new_delivered_at IS NULL")
  events.each do |event|
    ActiveRecord::Base.logger.info "#{event.id}.\n"
    User.find_by_event( event).each do |user| 
      mailing = EventMailer.deliver_new_event_of_interest( user, event)
      sleep 2 ## um nicht als spamversender eingestuft zu werden
    end
  end
  
  sleep 10

#  $running = false

end


def send_mails_on_new_events
end
