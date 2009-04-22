class Repository < ActiveRecord::Base
  include ApacheConfigMixins
    
  belongs_to :project
  
  SVN_ROOT = '/var/forge/svn'

  def repos_filepath
    "#{SVN_ROOT}/repos"
  end

  def repo_filepath
    "#{repos_filepath}/#{key}"
  end

  def httpd_conf_filepath
    "#{SVN_ROOT}/httpd.conf/#{key}"
  end
  
  def authz_filepath
    "#{SVN_ROOT}/authz/#{key}"
  end


  def before_save
    self.external_url = '' if use_internal?
  end
  
  def before_destroy
    return true unless exists_internally?

    # Disable the apache site file, reload the apache config, delete the apache site file, delete the repo permissions file,
    # and delete the repository.
    # conn = open_conn
    # disable_apache_site_file(apache_site_file_name, conn)     
    # reload_apache_config(conn)
    # remove_apache_site_file(apache_site_file_name, conn)
    # remove_file(authz_filepath, conn)
    # remove_directory(repo_filepath, conn)
    # close_conn(conn)
    true
  end
  
  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def exists_internally?
    path_exists?(repo_filepath)
  end  
  
  def internal_url
    "#{FORGE_URL}/svn/#{key}"
  end  
  
  def url
    use_internal? ? internal_url : external_url
  end

  def commits
    total_commits = 0
    begin
      IO.popen("svnlook youngest #{repo_filepath}") { |x| total_commits = x.gets.chomp.to_i } if exists_internally?
    rescue
    end
    total_commits
  end
  
  def last_commit_at
    last_commit_at_time = ''
    begin
      IO.popen("svnlook date #{repo_filepath}") { |x| last_commit_at_time = x.gets.gsub(/\+.*/, '') + ' UTC' } if exists_internally?
    rescue
    end
    last_commit_at_time
  end
  
  def create_internal(reload=true)
    return true if not use_internal?

    # Create the repo, create the permissions file, create the site file, enable the site file, and reload the apache config.
    conn = open_conn
    
    # Only create the repo if it does not exist
    if !remote_dir_exists?(conn, repo_filepath, APACHE_USER)
      remote_system(conn, "svnadmin create #{repo_filepath}", APACHE_USER)==0 or raise 'Error creating repository!'
    end
    
    # Generate the config files for the repo.
    remote_write(conn, authz_file_content, authz_filepath) 
    remote_write(conn, httpd_conf_content, httpd_conf_filepath)==0 or raise 'Error creating apache site file!'

    if reload
      reload_apache_config(conn)
    end
    true
    
  rescue => error
    puts "Error creating the svn repo: #{error}"
    print error.backtrace.join("\n")
    logger.error "Error creating the svn repo: #{error}"    
  ensure
    close_conn(conn)
  end    
  
  def make_private
    reset_perm_file(true)
  end
  
  def make_public
    reset_perm_file(false)
  end    
  
  def reset_perm_file(make_private)
    conn = open_conn
    create_file(make_private ? apache_repo_private_perm_file : apache_repo_public_perm_file, authz_filepath)
    reload_apache_config(conn)
    close_conn(conn)
    true
  end
  
  private
  
  def key
    self.project.shortname.downcase
  end

  def authz_file_content
    rc = <<EOF
[/]
* =
@#{CrowdGroup.forge_admin_group.name} = rw
EOF
    self.project.admin_groups.each do |group|
      rc += "@#{group.name} = rw\n"
    end
    self.project.member_groups.each do |group|
      rc += "@#{group.name} = rw\n"
    end
    
    rc += "@registered-users = r\n" if !self.project.is_private? 
    return rc;
  end

  def httpd_conf_content
    rc = <<EOF
<Location /forge/svn/#{key}>

  DAV svn
  SVNPath #{repo_filepath}

  AuthType Basic
  AuthName "FUSE Forge Repository"

  PerlAuthenHandler Apache::CrowdAuth
  PerlSetVar CrowdAppName ruby
  PerlSetVar CrowdAppPassword password
  PerlSetVar CrowdSOAPURL #{CROWD_URL}/services/SecurityServer

  PerlAuthzHandler Apache::CrowdAuthz
  PerlSetVar CrowdAuthzSVNAccessFile #{authz_filepath}

  require valid-user

</Location>
EOF
    return rc;
  end

end