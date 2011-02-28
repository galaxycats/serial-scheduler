class SerialScheduler::Converter
  
  class <<self
    def to_datetime(string_or_time_or_datetime)
      string_or_time_or_datetime.kind_of?(String) ?
        DateTime.parse(string_or_time_or_datetime) :
        string_or_time_or_datetime.to_datetime
    end
    
    def hour_and_minute(time_or_datetime)
      datetime = to_datetime(time_or_datetime)
      formated_hour_and_minute_string(datetime.hour, datetime.min)
    end
    
    def to_hour_and_minute(time_or_datetime)
      hour_and_minute(time_or_datetime)
    end
  
    def hour_and_minute_in_5_minute_steps(time_or_datetime)
      datetime = to_datetime(time_or_datetime)
      minutes = floor_to_five(datetime.min)
      formated_hour_and_minute_string(datetime.hour, minutes)
    end
  
    def weekday_hour_and_minute_in_5_minute_steps(time_or_datetime)
      datetime = to_datetime(time_or_datetime)
      "#{datetime.wday}:#{hour_and_minute_in_5_minute_steps(datetime)}"
    end
  
    def floor_to_five(fixnum)
      unit_digit = fixnum % 10
      if unit_digit < 5
        fixnum - unit_digit
      else
        fixnum - (unit_digit - 5)
      end
    end
    
    def formated_hour_and_minute_string(hours, minutes)
      minutes = minutes < 10 ? "0#{minutes}" : "#{minutes}"
      hours = hours < 10 ? "0#{hours}" : "#{hours}"
      "#{hours}:#{minutes}"
    end

    def hours_between(from, to)
      hours = []
      for_each_hour(from,to) do |hour|
        hours << hour
      end
      hours
    end

    def for_each_hour(from, to)
      for_each_time_with_step(from, to, 1.hour) do |time|
        yield(time)
      end
    end

    def for_each_time_with_step(from, to, step)
      current_time = DateTime.parse(from)
      max_time = DateTime.parse(to)
      max_time = max_time + 1.day if max_time <= current_time
      while current_time <= max_time
        yield(SerialScheduler::Converter.to_hour_and_minute(current_time))
        current_time += step
      end
    end

  end
end