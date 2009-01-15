module LocalizationSimplified
  class DateHelper
    Texts = {
      :less_than_x_seconds => "weniger als %d Sekunden",
      :half_a_minute       => "einer halben Minute",
      :less_than_a_minute  => "weniger als einer Minute",
      :one_minute          => "einer Minute",
      :x_minutes           => "%d Minuten",
      :one_hour            => "gut einer Stunde",
      :x_hours             => "gut %d Stunden",
      :one_day             => "weniger als zwei Tagen",
      :x_days              => "weniger als %d Tagen",
      :one_month           => "einem Monat",
      :x_months            => "%d Monaten",
      :one_year            => "einem Jahr",
      :x_years             => "%d Jahren"
    }
  end
end

Time::DATE_FORMATS[:rfc822] = proc do |time|
  time.strftime("#{Time::RFC2822_DAY_NAME[time.wday]}, %d #{Time::RFC2822_MONTH_NAME[time.mon-1]} %Y %H:%M:%S %z")
end
  