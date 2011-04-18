class SerialScheduler::Logger
  
  class <<self
    
    def log(type, *args)
      puts "[#{type.upcase}] #{args}"
    end
    
    %w(debug info warn error fatal).each do |type|
      define_method type do |*args|
        log(type, *args)
      end
    end
    
  end
  
end