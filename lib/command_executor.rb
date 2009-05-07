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
  
  def write(content, remote_file, user=nil)
    system("cat > '#{remote_file}'", user, content)
    # system("tee '#{remote_file}' > /dev/null", user, content)
  end

  def copy(local_file, remote_file, user=nil)
    File.open(local_file, "r") do |file|
      system("cat > '#{remote_file}'", user, file)
      # system("tee '#{remote_file}' > /dev/null", user, file)
    end
  end

  def file_exists?(file, user=nil)
    system("[ -f #{file} ]", user)==0 ? true : false
  end

  def dir_exists?(dir, user=nil)
    system("[ -d #{dir} ]", user)==0 ? true : false
  end
  
  def system(command, user=nil, input=nil)
    if user
      command.gsub("'", "\\\\'")
      command = "sudo -u #{user} sh -c '#{command}'"
    end
    if @ssh
      benchmark("SSH Command", command) do
        
        @output = ""
        rc=-1
        exit_signal=0
        
        channel = @ssh.open_channel do |channel|
          # Register the callbacks...
          channel.on_data do |channel, data|
            @output << data
          end
          channel.on_extended_data do |channel, type, data|
            if type==1
              $stderr.print(data)
            end
          end
        	channel.on_request("exit-status") do |channel, data|
        		rc = data.read_long
        	end
        	channel.on_request("exit-signal") do |channel, data|
        		exit_signal = data.read_long
        	end
        	
          channel.exec(command) do |channel, success|
            raise "could not execute command: #{command.inspect}" unless success
            
            if input 
              if input.class == String
                channel.send_data input
              else
                # Assume it's a IO object we can read.
                while (data = input.read(1024))
                    channel.send_data data
                end
              end
            end
            channel.process
            channel.eof!
          end
        end
        channel.wait
        return rc
      end
    else
      benchmark("System Command", command) do
        IO.popen(command, 'r+') do |pipe|          
          if input 
            if input.class == String
              pipe.print input
            else
              # Assume it's a IO object we can read.
              while (data = input.read(1024))
                  pipe.print data
              end
            end
          end        
          pipe.close_write
          @output = pipe.read
        end
        $?
      end
    end
  end
    
  def output
    @output
  end
  
  def ssh=(ssh)
    @ssh=ssh
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
      titile_color, details_color, result_color, end_color = "\e[4;32;1m", "\e[0;1m", "\e[4;32;1m", "\e[0m"
    #else
    #  titile_color, details_color, end_color = "", "", ""
    #end    
    log_entry = "  #{titile_color}#{title} (#{sprintf("%.1f", seconds * 1000)}ms)#{end_color}"
    log_entry << "#{details_color}:  #{details}#{end_color} : #{result_color}#{result}#{end_color}" if details
    log_entry
  end

end