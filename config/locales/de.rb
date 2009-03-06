{
  :de => {
  
    :date => {
      :formats => {
        :default => "%d.%m.%Y",
        :short => "%e. %b",
        :long => "%e. %B %Y",
        :day_abbr => "%a",
        :month_abbr => "%b"
      },
        
      :day_names => %w{Sonntag Montag Dienstag Mittwoch Donnerstag Freitag Samstag},
      :abbr_day_names => %w{So Mo Di Mi Do Fr Sa},
      :month_names => %w{~ Januar Februar März April Mai Juni Juli August September Oktober November Dezember},
      :abbr_month_names => %w{~ Jan Feb Mär Apr Mai Jun Jul Aug Sep Okt Nov Dez},
      :order => [ :day,  :month,  :year]
    },
  
    :time => {
      :am => "",
      :pm => "",
      :formats => {
        :default => "%d.%m.%Y %H:%M",
        :time => "%H:%M",
        :day_month => "%d.%b.",
        :day_month_year => "%d.%m.%Y",
        :day_abbr => "%a",
        :month_abbr => "%b",
        :short => "%e.%m. %H:%M",
        :long => "%A, %e. %B %Y, %H:%M",      
        :nice => lambda do |time|
          now = Time.now
          if time.to_date == now.to_date
            "%H:%M"
          elsif time.to_date.eql?(now.to_date - 1)
            "Gestern"
          elsif time.year == now.year
            "%d.%b."
          else
            "%d.%m.%Y"
          end
        end
      }
    }
  } 
}
