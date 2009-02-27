require 'net/ssh'

module ApacheConfigMixins
  APACHE_USER = 'www-data'
  HOST = ['forge', 'source'].include?(Socket.gethostname) ? "fusesource.com/forge" : "fusesourcedev.com/forge"
  LOGIN_USER = 'root'
 
  
  def open_conn
    RAILS_ENV == 'development' ? Net::SSH.start(HOST, LOGIN_USER) : nil
  end
  
  def close_conn(conn)
    conn.close unless conn.nil?
  end
  
  def path_exists?(path_str)
    conn = open_conn
    if conn
      conn.exec!("[ -d #{path_str} ] && echo 'true' || echo 'false'").chomp == 'true' ? true : false
    else
      system("[ -d #{path_str} ]")
    end
  rescue
    logger.error "Error checking for directory!: #{path_str}"
  ensure
    close_conn(conn)  
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
    run_cmd_str("sudo -u www-data mkdir #{path_str}", 'Error creating directory!', conn)
  end
    
  def remove_directory(path_str, conn=nil)
    run_cmd_str("sudo -u www-data rm -rf #{path_str}", 'Error removing directory!', conn)
  end  

  def create_file(file_contents, file_path, conn=nil)
    run_cmd_str("echo '#{file_contents}' > #{file_path}", 'Error creating file!', conn)
  end

  def remove_file(path_str, conn=nil)
    run_cmd_str("rm #{path_str}", 'Error removing file!', conn)
  end  

  def chown_dir(path_str, conn=nil)
    run_cmd_str("sudo chown -R www-data:www-data #{path_str}", 'Error chowning directory!', conn)
  end
    
  def run_cmd_str(cmd_str, err_msg, conn)
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