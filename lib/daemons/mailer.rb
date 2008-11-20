#!/usr/bin/env ruby

class MailerDaemon

  SleepBetweenMails = 2
  SleepBetweenIterations = 60


## mails bei neuen events zu einem abonnierten thema (tag)
  def self.send_mails_on_new_events
    # die demo ist neu und wurde zum letzten mal vor 2 stunden geupdated
    events =  Event.find(:all, :conditions => ['new_delivered_at IS NULL AND updated_at < ?', 2.hours.ago ])
    events.each do |event|
      User.find_by_event( event).each do |user|
        EventMailer.deliver_new_event_of_interest( user, event)
        sleep SleepBetweenMails
      end
      event.update_attribute(:new_delivered_at, Time.now)
    end
  end


#  def self.send_reminder_mails( reminder_number, hours_before_begin)
#    events =  Event.find(:all, 
#      :conditions => ['reminder_' + reminder_number.to_s + '_delivered_at IS NULL 
#                        AND new_delivered_at IS NOT NULL 
#                        AND startdate > ?
#                        AND startdate <= ?', Time.now, Time.now + 3600*hours_before_begin ])
#    events.each do |event|
#      User.find_by_event( event).each do |user|
#        EventMailer.deliver_reminder( user, event)
#        sleep 2
#      end
#      event.update_attribute('reminder_' + reminder_number.to_s + '_delivered_at', Time.now)
#    end
#  end



## reminder mails fuer gebookmarkte events
  def self.send_reminder_mails( reminder_number, hours_before_begin)
    events =  Event.find(:all,
                :conditions => ['startdate > ? AND startdate <= ?', Time.now, Time.now + 3600*hours_before_begin ])
    events.each do |event|
      bmarks = Bookmark.find(:all, 
          :conditions=>["bookmarkable_type='event' 
                      AND reminder_" + reminder_number.to_s + "_delivered_at IS NULL
                      AND bookmarkable_id=?", event.id])
      bmarks.each do |bm|
        user = User.find( bm.user_id)
        EventMailer.deliver_reminder( user, event)
        bm.update_attribute('reminder_' + reminder_number.to_s + '_delivered_at', Time.now)
        sleep SleepBetweenMails
      end
    end
  end



  def self.run
    # You might want to change this
    ENV["RAILS_ENV"] ||= "development"

    require File.dirname(__FILE__) + "/../../config/environment"

    $running = true
    Signal.trap("TERM") do
      $running = false
    end

    while($running) do
      # Replace this with your code
      ActiveRecord::Base.logger.info "#{Time.now}: MailerDaemon: Checking for new mail delivery tasks.\n"
      send_mails_on_new_events
      send_reminder_mails( 1, 24*7)
      send_reminder_mails( 2, 24)
      ActiveRecord::Base.logger.info "#{Time.now}: MailerDaemon: Sleeping " + SleepBetweenIterations.to_s + " seconds.\n"
      sleep SleepBetweenIterations
    end
  end


end



MailerDaemon.run

