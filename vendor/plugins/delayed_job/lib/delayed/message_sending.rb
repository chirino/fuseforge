module Delayed
  module MessageSending
    def send_later(method, *args)
      priority = nil
      run_at   = nil
      case method
      when String
        method = method.to_sym
      when Hash
        priority = method[:priority]
        run_at = method[:run_at]
        args = method[:args] if method[:args]
        method = method[:method].to_sym
      end
      Delayed::Job.enqueue Delayed::PerformableMethod.new(self, method, args), priority, run_at
    end
        
    module ClassMethods
      def handle_asynchronously(method)
        without_name = "#{method}_without_send_later"
        define_method("#{method}_with_send_later") do |*args|
          send_later(without_name, *args)
        end
        alias_method_chain method, :send_later
      end
    end
  end                               
end