require 'test_helper'

class DslTest < ActiveSupport::TestCase
  
  test "should create time keys by symbol :hour" do
    assert_equal ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00",
     "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"], SerialScheduler::Dsl.new.time_keys_by_symbol(:hour)
    
    assert_equal ["08:00", "09:00", "10:00", "11:00", "12:00", "13:00",
      "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00"], SerialScheduler::Dsl.new.time_keys_by_symbol(:hour, :from => "8:00", :to => "20:00")
  end
  
  test "should create time keys by time step size (duration)" do
    expected_time_keys = []
    SerialScheduler::Converter.for_each_time_with_step("00:00", "23:55", 5.minutes) { |time_key| expected_time_keys << time_key }
    assert_equal expected_time_keys, SerialScheduler::Dsl.new.time_keys_by_duration(5.minutes)
    
    assert_equal ["11:23", "11:28", "11:33"], SerialScheduler::Dsl.new.time_keys_by_duration(5.minutes, :from => "11:23", :to => "11:37")
  end
  
  test "should create time key for a day symbol with 'at' condition" do
    assert_equal ["5:00:00"], SerialScheduler::Dsl.new.time_keys_by_symbol(:friday)
  end
  
  test "should extract from and to from options or return defaults" do
    dsl = SerialScheduler::Dsl.new
    assert_equal ["08:00", "09:00"], dsl.extract_from_to_or_default({:from => "8:00", :to => "9:00"})
    assert_equal ["12:00", "13:00"], dsl.extract_from_to_or_default({:from => "12:00", :to => "13:00"})
    assert_equal ["00:00", "23:59"], dsl.extract_from_to_or_default(nil)
  end

  test "should extract at from options or return default" do
    dsl = SerialScheduler::Dsl.new
    assert_equal "00:00", dsl.extract_at_or_default({:at => "0:00"})
    assert_equal "12:00", dsl.extract_at_or_default({:at => "12:00"})
    assert_equal "00:00", dsl.extract_at_or_default(nil)
  end

  test "should create time stamps for every :day" do
    assert_equal "03:00", SerialScheduler::Dsl.new.time_keys_by_symbol(:day, :at => "3:00")
  end
  
end