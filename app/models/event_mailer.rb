# sending mails at new / updated / current events

class EventMailer < ActionMailer::Base

  def new_event_of_interest( user, event)
    setup_email(user)
    @subject    += "Demo am #{event.startdate.strftime('%a, %d. %b %Y')}: #{event.title}"
    @body[:event]  = event
  end




protected
  def setup_email(user)
    @recipients  = user.email
    @from        = "no-reply@demowatch.eu"
    @subject     = "[www.demowatch.eu] "
    @sent_on     = Time.now
    @body[:user] = user
    @content_type = 'text/html'
  end
  
end


#   3  Format meaning:
#   4  
#   5    %a - The abbreviated weekday name (``Sun'')
#   6    %A - The  full  weekday  name (``Sunday'')
#   7    %b - The abbreviated month name (``Jan'')
#   8    %B - The  full  month  name (``January'')
#   9    %c - The preferred local date and time representation
#  10    %d - Day of the month (01..31)
#  11    %H - Hour of the day, 24-hour clock (00..23)
#  12    %I - Hour of the day, 12-hour clock (01..12)
#  13    %j - Day of the year (001..366)
#  14    %m - Month of the year (01..12)
#  15    %M - Minute of the hour (00..59)
#  16    %p - Meridian indicator (``AM''  or  ``PM'')
#  17    %S - Second of the minute (00..60)
#  18    %U - Week  number  of the current year,
#  19            starting with the first Sunday as the first
#  20            day of the first week (00..53)
#  21    %W - Week  number  of the current year,
#  22            starting with the first Monday as the first
#  23            day of the first week (00..53)
#  24    %w - Day of the week (Sunday is 0, 0..6)
#  25    %x - Preferred representation for the date alone, no time
#  26    %X - Preferred representation for the time alone, no date
#  27    %y - Year without a century (00..99)
#  28    %Y - Year with century
#  29    %Z - Time zone name
#  30    %% - Literal ``%'' character
#  31  

