require 'test_helper'

class SerialSchedulerTest < ActiveSupport::TestCase
  
  def setup
    SerialScheduler::TimeTable.clear
  end

  test "should evaluate a definition with every hour" do
    SerialScheduler.define :test do
      schedule "some importer" do
        lastminute { every :hour }
      end
    end
    assert_equal(
      ["00:00", "01:00", "02:00", "03:00", "04:00", "05:00", "06:00", "07:00", "08:00", "09:00", "10:00", "11:00",
       "12:00", "13:00", "14:00", "15:00", "16:00", "17:00", "18:00", "19:00", "20:00", "21:00", "22:00", "23:00"],
      SerialScheduler::TimeTable.timing.keys.sort
    )
    SerialScheduler::TimeTable.timing.values.each do |vals|
      assert_kind_of Array, vals
      assert vals.all? { |val| val.kind_of?(SerialScheduler::Dsl::CallWrapper) }
    end
  end
end
