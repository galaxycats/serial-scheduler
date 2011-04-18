require 'test_helper'

class RunnerTest < ActiveSupport::TestCase
  
  class MockReceiver; end
  
  def setup
    SerialScheduler::TimeTable.clear
    SerialScheduler.define :test do
      schedule RunnerTest::MockReceiver do
        lastminute   { every :hour,   :from => "8:00", :to => "20:00" }
        availability { every 2.hours, :from => "0:00", :to => "4:00" }
        houses       { every :monday, :at => "0:00" }
      end
    end
  end
  
  test "should run all relevant jobs for given time" do
    MockReceiver.expects(:houses)
    MockReceiver.expects(:availability)
    SerialScheduler::Runner.run("27.12.2010 00:00".to_datetime)
  end
  
  test "should dry-run all relevant jobs for given time" do
    MockReceiver.expects(:houses).never
    MockReceiver.expects(:availability).never
    SerialScheduler::Runner.dry_run("27.12.2010 00:00".to_datetime)
  end
  
  test "should catch all exceptions during job execution and send an email to developers" do
    if defined?(Rails)
      MockReceiver.expects(:lastminute).raises(ArgumentError, "Hello from test")
      Notifier.expects(:deliver_scheduler_error)
      SerialScheduler::Runner.run("27.12.2010 8:00".to_datetime)
    end
  end
  
  test "should log executions to info" do
    SerialScheduler.logger.expects(:info).times(2)
    SerialScheduler::Runner.run("27.12.2010 00:00".to_datetime)
  end

  test "should log failed-executions to error" do
    exception = NoMethodError.new("this is the no method exception")
    RunnerTest::MockReceiver.expects(:lastminute).raises exception
    SerialScheduler.logger.expects(:info)
    SerialScheduler.logger.expects(:error)
    SerialScheduler::Runner.run("27.12.2010 09:00".to_datetime)
  end
end