require 'singleton'

class SerialScheduler::TimeTable
  include Singleton
  
  attr_reader :timing
  
  def initialize
    @timing = {}
  end
  
  class <<self
    def jobs_for(*time_keys)
      [time_keys].flatten.collect do |time_key|
        timing[time_key]
      end.flatten.compact
    end
    
    def method_missing(meth, *args, &blk)
      if self.instance.respond_to?(meth)
        self.instance.send(meth, *args, &blk)
      else
        super
      end
    end
  end

  def add(hash_with_timing_info)
    hash_with_timing_info.each do |timing_key, calls|
      self.timing[timing_key] ||= []
      self.timing[timing_key] += [calls].flatten
    end
  end
  
  def clear
    self.timing = {}
  end
  
  def weekly_timing
    timing.reject { |time_key, call| time_key.size != 7 }
  end
  
  def daily_timing
    timing.reject { |time_key, call| time_key.size != 5 }
  end
  
  def print
    print_daily_timing
    print_weekly_timing
  end
  
  def print_daily_timing
    puts
    puts "daily timing"
    puts "-"*15
    daily_timing.keys.sort.each do |time_key|
      scheduled_calls = timing[time_key]
      puts "#{time_key} |\t#{scheduled_calls.join("\n\t")}"
    end
  end
  
  def print_weekly_timing
    puts
    puts "weekly timing"
    puts "-"*15
    weekly_timing.keys.sort.each do |time_key|
      scheduled_calls = timing[time_key]
      puts "#{Date.human_wday(time_key.first.to_i)}, #{time_key[2..-1]} |\t#{scheduled_calls.join("\n\t")}"
    end
  end
  
  private
    attr_writer :timing
end
