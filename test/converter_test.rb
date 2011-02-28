require 'test_helper'

class ConverterTest < ActiveSupport::TestCase
  
  test "should calculate hour and minute string floored in 5 minute steps" do
    assert_equal "11:55", SerialScheduler::Converter.hour_and_minute_in_5_minute_steps("17.12.2010 11:59".to_datetime)
    assert_equal "12:00", SerialScheduler::Converter.hour_and_minute_in_5_minute_steps("17.12.2010 12:00".to_datetime)
    assert_equal "12:00", SerialScheduler::Converter.hour_and_minute_in_5_minute_steps("17.12.2010 12:04".to_datetime)
    assert_equal "12:05", SerialScheduler::Converter.hour_and_minute_in_5_minute_steps("17.12.2010 12:05".to_datetime)
    assert_equal "12:05", SerialScheduler::Converter.hour_and_minute_in_5_minute_steps("17.12.2010 12:06".to_datetime)
  end

  test "should calculate weekday, hour and minute string floored in 5 minute steps" do
    assert_equal "#{Date::FRIDAY}:11:55", SerialScheduler::Converter.weekday_hour_and_minute_in_5_minute_steps("17.12.2010 11:59".to_datetime)
    assert_equal "#{Date::SATURDAY}:12:00", SerialScheduler::Converter.weekday_hour_and_minute_in_5_minute_steps("18.12.2010 12:00".to_datetime)
    assert_equal "#{Date::SUNDAY}:12:00", SerialScheduler::Converter.weekday_hour_and_minute_in_5_minute_steps("19.12.2010 12:04".to_datetime)
    assert_equal "#{Date::MONDAY}:12:05", SerialScheduler::Converter.weekday_hour_and_minute_in_5_minute_steps("20.12.2010 12:05".to_datetime)
    assert_equal "#{Date::TUESDAY}:12:05", SerialScheduler::Converter.weekday_hour_and_minute_in_5_minute_steps("21.12.2010 12:06".to_datetime)
    assert_equal "#{Date::WEDNESDAY}:14:05", SerialScheduler::Converter.weekday_hour_and_minute_in_5_minute_steps("22.12.2010 14:06".to_datetime)
    assert_equal "#{Date::THURSDAY}:18:05", SerialScheduler::Converter.weekday_hour_and_minute_in_5_minute_steps("23.12.2010 18:06".to_datetime)
  end

  test "should round (floor) numbers in steps of 5" do
    assert_equal 0, SerialScheduler::Converter.floor_to_five(1)
    assert_equal 0, SerialScheduler::Converter.floor_to_five(4)
    assert_equal 5, SerialScheduler::Converter.floor_to_five(5)
    assert_equal 5, SerialScheduler::Converter.floor_to_five(6)
    assert_equal 5, SerialScheduler::Converter.floor_to_five(9)
    assert_equal 10, SerialScheduler::Converter.floor_to_five(10)
    assert_equal 10, SerialScheduler::Converter.floor_to_five(11)
  end
  
  test "should format hour and minute as a string with two and two digits" do
    assert_equal "01:09", SerialScheduler::Converter.formated_hour_and_minute_string(1, 9)
    assert_equal "12:00", SerialScheduler::Converter.formated_hour_and_minute_string(12, 0)
    assert_equal "14:03", SerialScheduler::Converter.formated_hour_and_minute_string(14, 3)
    assert_equal "23:59", SerialScheduler::Converter.formated_hour_and_minute_string(23, 59)
  end
  
  test "should return an array with all hours between two hours" do
    assert_equal ["23:00", "00:00", "01:00", "02:00"], SerialScheduler::Converter.hours_between("23:00", "02:00")
    assert_equal ["03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00", "12:00", "13:00", "14:00",
      "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00", "00:00", "01:00", "02:00", "03:00"], SerialScheduler::Converter.hours_between("03:00", "03:00")
    assert_equal ["03:00", "04:00"], SerialScheduler::Converter.hours_between("03:00", "04:00")
    assert_equal ["03:00"], SerialScheduler::Converter.hours_between("03:00", "03:01")
    assert_equal ["08:00", "09:00", "10:00", "11:00", "12:00", "13:00"], SerialScheduler::Converter.hours_between("08:00", "13:00")
  end
  
  
end