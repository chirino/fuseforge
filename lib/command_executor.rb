require 'net/ssh'

class CommandExecutor
  
  def self.open(ssh_config=nil, &block)
    ce = CommandExecutor.new 
    ce.ssh = Net::SSH.start(ssh_config[:host], ssh_config[:user], ssh_config[:options]) if ssh_config
    if( block ) 
      begin
        return block.call(ce)
      ensure
        ce.close
      end
    else
      return ce
    end
  end
  
  def close
    @ssh.close && @ssh=nil if @ssh
    return 'crap'
  end
  
  def write(content, file, user=nil)
      system("tee '#{file}' > /dev/null <<EOF\n#{content}\nEOF", user)
  end

  def file_exists?(file, user=nil)
    system("[ -f #{file} ]", user)==0 ? true : false
  end

  def dir_exists?(dir, user=nil)
    system("[ -d #{dir} ]", user)==0 ? true : false
  end
  
  def system(command, user=nil)
    command = "sudo -u #{user} "+command if user
    if @ssh
      benchmark("SSH Command", command) do
        @output = @ssh.exec(command)
        return @ssh.exec!("echo $?").to_i
      end
    else
      benchmark("System Command", command) do
        @output = `#{command}`
        return $?
      end
    end
  end 
  
  def output
    @output
  end
  
  private

  def benchmark(title, details, log_level=Logger::DEBUG)
    logger = ActiveRecord::Base.logger;
    if logger && logger.level <= log_level
      result = nil
      seconds = Benchmark.realtime { result = yield }
      logger.add(log_level, format_benchmark_log_message(seconds, title, result, details))
      result
    else
      yield
    end
  end
  
  def format_benchmark_log_message(seconds, title, result, details)
    #if( @colorize_logging ) 
      titile_color, details_color, result_color, end_color = "\e[4;34;1m", "\e[0;1m", "\e[4;32;1m", "\e[0m"
    #else
    #  titile_color, details_color, end_color = "", "", ""
    #end    
    log_entry = "  #{titile_color}#{title} (#{sprintf("%.1f", seconds * 1000)}ms)#{end_color}"
    log_entry << "#{details_color}:  #{details}#{end_color} : #{result_color}#{result}#{end_color}" if details
    log_entry
  end

end