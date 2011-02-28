class SerialScheduler::Runner
  
  class <<self
  
    def run(time, options = {})
      daily_time_key = SerialScheduler::Converter.hour_and_minute_in_5_minute_steps(time)
      weekly_time_key = SerialScheduler::Converter.weekday_hour_and_minute_in_5_minute_steps(time)
      jobs = SerialScheduler::TimeTable.jobs_for([weekly_time_key, daily_time_key].compact)
      jobs.each do |job|
        begin
          if options[:dry_run]
            puts ">> #{job}"
          else
            job.call
          end
        rescue => e
          if defined?(Rails)
            raise e if Rails.env.development?
            Notifier.deliver_scheduler_error(e, job, time)
          end
        end
      end
    end

    def dry_run(time)
      run(time, :dry_run => true)
      puts ">> end"
    end
    
  end
  
end