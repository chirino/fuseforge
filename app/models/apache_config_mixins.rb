require 'net/ssh'

module ApacheConfigMixins
  
  APACHE_USER = SVN_DAV_HOST[:apache_user]
  APACHE_GROUP = SVN_DAV_HOST[:apache_group]
  
  def open_conn
    SVN_DAV_HOST.has_key?(:ssh) ? Net::SSH.start(SVN_DAV_HOST[:ssh][:host], SVN_DAV_HOST[:ssh][:user], SVN_DAV_HOST[:ssh][:options]) : nil;
  end
  
  def close_conn(conn)
    conn.close unless conn.nil?
  end
  
  
  def remote_write(conn, content, file, user=nil)
      remote_system(conn, "tee '#{file}' > /dev/null <<EOF\n#{content}\nEOF", user)
  end

  def remote_file_exists?(conn, file, user=nil)
    remote_system(conn, "[ -f #{file} ]", user)==0 ? true : false
  end

  def remote_dir_exists?(conn, dir, user=nil)
    remote_system(conn, "[ -d #{dir} ]", user)==0 ? true : false
  end
  
  def remote_system(conn, command, user=nil)
    command = "sudo -u #{user} "+command if user
    if conn
      benchmark("SSH Command", command) do
        conn.exec(command)
        conn.exec!("echo $?").to_i
      end
    else
      benchmark("System Command", command) do
        system(command)
        $?
      end
    end
  end  

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

  def reload_apache_config(conn=nil)
    run_cmd_str('sudo /etc/init.d/apache2 reload', 'Error reloading apache config!', conn)
  end    
  
  def enable_apache_site_file(site_file_name, conn=nil)
    run_cmd_str("sudo a2ensite #{site_file_name}", 'Error enabling apache site!', conn)
  end  
  
  def disable_apache_site_file(site_file_name, conn=nil)
    run_cmd_str("sudo a2dissite #{site_file_name}", 'Error disabling apache site!', conn)
  end  
  
  def create_apache_site_file(site_file_contents, site_file_name, conn=nil)
    run_cmd_str("echo '#{site_file_contents}' > /etc/apache2/sites-available/#{site_file_name}", 'Error creating apache site file!', conn)
  end  
  
  def remove_apache_site_file(site_file_name, conn=nil)
    run_cmd_str("rm /etc/apache2/sites-available/#{site_file_name}", 'Error deleting apache site file!', conn)
  end  

  def create_directory(path_str, conn=nil)
    run_cmd_str("sudo -u #{APACHE_USER} mkdir #{path_str}", 'Error creating directory!', conn)
  end
    
  def remove_directory(path_str, conn=nil)
    run_cmd_str("sudo -u #{APACHE_USER} rm -rf #{path_str}", 'Error removing directory!', conn)
  end  

  def create_file(file_contents, file_path, conn=nil)
    run_cmd_str("echo '#{file_contents}' > #{file_path}", 'Error creating file!', conn)
  end

  def remove_file(path_str, conn=nil)
    run_cmd_str("rm #{path_str}", 'Error removing file!', conn)
  end  

  def chown_dir(path_str, conn=nil)
    run_cmd_str("sudo chown -R #{APACHE_USER}:#{APACHE_GROUP} #{path_str}", 'Error chowning directory!', conn)
  end
  
  def file_exists?(conn, path_str )
    if conn
      conn.exec!("[ -f #{path_str} ] ; echo $?").to_i
    else
      system("[ -f #{path_str} ]")
    end
  end

  def path_exists?(path_str)
    conn = open_conn
    if conn
      conn.exec!("[ -d #{path_str} ] ; echo $?").to_i
    else
      system("[ -d #{path_str} ]")
    end
  rescue
    logger.error "Error checking for directory!: #{path_str}"
  ensure
    close_conn(conn)  
  end
    
  def run_cmd_str(cmd_str, err_msg, conn)
    puts "DEBUG Running: #{cmd_str}"
    if conn
      conn.exec!(cmd_str)
    else
      raise unless system(cmd_str)
    end
    true
  rescue
    logger.error "#{err_msg}: #{cmd_str}"
  end  
end