class SerialScheduler::Dsl

  class CallWrapper
    attr_reader :callee, :meth
    def initialize(callee, meth)
      @callee = callee
      @meth = meth
    end
    
    def call
      instance_to_call = callee.kind_of?(String) ? callee.constantize : callee
      instance_to_call.send(meth)
    end
    
    def to_s
      "#{callee}.#{meth}"
    end
  end
  
  attr_accessor :callee
  
  
  # How to use the scheduler
  #
  # With the scheduler DSL you can define jobs in a simple language
  # 
  # Example:
  #   
  #   schedule AnyReceiver do
  #     some_method { every :hour }
  #     some_other_method { every 2.hours, :from => "9:00", :to => "18:00" }
  #     and_another_method { every :friday, :at => "3:00" }
  #   end
  
  def schedule(callee, &block)
    self.callee = callee
    self.instance_eval(&block)
  end
  
  def every(*args)
    case args.first
    when Symbol
      time_keys_by_symbol(*args)
    when ActiveSupport::Duration
      time_keys_by_duration(*args)
    else
      raise "SerialScheduler::Dsl - every - You have to specify either a symbol or a duration (was #{args.first.inspect})"
    end
  end
  
  def time_keys_by_symbol(*args)
    time_keys = []
    options = args.extract_options!
    case args.first
    when :hour
      from, to = extract_from_to_or_default(options)
      time_keys = SerialScheduler::Converter.hours_between(from, to)
    when :day
      time_keys = extract_at_or_default(options)
    else
      at = extract_at_or_default(options)
      day = args.first
      if [:monday, :tuesday, :wednesday, :thursday, :friday, :saturday, :sunday].include?(day)
        time_keys << "#{Date.const_get(day.to_s.upcase)}:#{at}"
      end
    end
    return time_keys
  end
  
  def time_keys_by_duration(*args)
    options = args.extract_options!
    from, to = extract_from_to_or_default(options)
    step = args.first
    time_keys = []
    SerialScheduler::Converter.for_each_time_with_step(from, to, step) do |time_key|
      time_keys << time_key
    end
    time_keys
  end
  
  def extract_from_to_or_default(options)
    options ||= {}
    from = options[:from] ? SerialScheduler::Converter.to_hour_and_minute(options[:from]) : "00:00"
    to = options[:to] ? SerialScheduler::Converter.to_hour_and_minute(options[:to]) : "23:59"
    return from, to
  end
  
  def extract_at_or_default(options)
    options ||= {}
    options[:at] ? SerialScheduler::Converter.to_hour_and_minute(options[:at]) : "00:00"
  end
  
  def create_time_table_with_time_keys(time_keys, callee, meth)
    time_keys.inject({}) do |time_table, time_key|
      time_table[time_key] = CallWrapper.new(callee, meth)
      time_table
    end
  end
  
  def method_missing(meth, *args, &blk)
    if block_given?
      time_keys = instance_eval(&blk)
      SerialScheduler::TimeTable.add(create_time_table_with_time_keys(time_keys, self.callee, meth))
    else
      super
    end
  end
  
end