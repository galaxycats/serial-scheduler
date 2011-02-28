Date::DAYNAMES.each_with_index do |dayname, idx|
  Date.const_set(dayname.upcase, idx)
end

def Date.human_wday(number)
  Date::DAYNAMES[number].to_s.capitalize
end