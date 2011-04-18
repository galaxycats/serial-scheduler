module SerialScheduler
  
  class <<self
  
    def define(environment_target, &block)
      SerialScheduler::Dsl.new.instance_eval(&block) if !defined?(Rails) || environment_target == Rails.env.to_sym
    end

    def run(time = Time.now)
      SerialScheduler::Runner.run(time)
    end
    
    def dry_run(time = Time.now)
      SerialScheduler::Runner.dry_run(time)
    end
    
    if defined?(NewRelic)
      include NewRelic::Agent::Instrumentation::ControllerInstrumentation
      add_transaction_tracer :run, :category => :task
    end
    
    if defined?(Rails)
      def logger
        Rails.logger
      end
    else
      def logger
        SerialScheduler::Logger
      end
    end
    
  end
  
end

require "serial_scheduler/date_day_names_core_extension"
require "serial_scheduler/converter"
require "serial_scheduler/dsl"
require "serial_scheduler/runner"
require "serial_scheduler/time_table"
require "serial_scheduler/logger"