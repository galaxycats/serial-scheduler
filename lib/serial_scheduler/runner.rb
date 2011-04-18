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
            SerialScheduler.logger.info("executing '#{job}'", :_job => "#{job}")
            start_time = Time.now
            job.call
            end_time = Time.now
            SerialScheduler.logger.info("successfully executed '#{job}' in #{(end_time - start_time)} seconds", :_job => "#{job}", :_execution_time => (end_time - start_time))
          end
        rescue => e
          SerialScheduler.logger.error(e, :_job => "#{job}", :_execution_time => (start_time ? Time.now - start_time : "?"))
          raise e if defined?(Rails) && Rails.env.development?
        end
      end
      
    end

    def dry_run(time)
      run(time, :dry_run => true)
      puts ">> end"
    end
    
  end
  
end