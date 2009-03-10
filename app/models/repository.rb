class Repository < ActiveRecord::Base
  include ApacheConfigMixins
    
  belongs_to :project
  
  INTERNAL_HOST = Socket.gethostname == 'dude' ? 'forge.fusesource.com' : 'fusesourcedev.com/forge'
  REPO_PATH = '/var/svn/repos'
  APACHE_REPO_PERMS_PATH = '/etc/apache2/fuseforge'
  APACHE_REPO_PERMS_EXT = 'authz'
  APACHE_SITE_PREFIX = 'svn_'

  def before_save
    self.external_url = '' if use_internal?
  end
  
  def before_destroy
    return true unless exists_internally?

    # Disable the apache site file, reload the apache config, delete the apache site file, delete the repo permissions file,
    # and delete the repository.
    conn = open_conn
    disable_apache_site_file(apache_site_file_name, conn)     
    reload_apache_config(conn)
    remove_apache_site_file(apache_site_file_name, conn)
    remove_file(apache_repo_perm_filepath, conn)
    remove_directory(repo_path, conn)
    close_conn(conn)
    true
  end
  
  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def exists_internally?
    path_exists?(repo_path)
  end  
  
  def internal_url
    "http://#{INTERNAL_HOST}/svn/#{key}"
  end  
  
  def url
    use_internal? ? internal_url : external_url
  end

  def commits
    total_commits = 0
    begin
      IO.popen("svnlook youngest #{repo_path}") { |x| total_commits = x.gets.chomp.to_i } if exists_internally?
    rescue
    end
    total_commits
  end
  
  def last_commit_at
    last_commit_at_time = ''
    begin
      IO.popen("svnlook date #{repo_path}") { |x| last_commit_at_time = x.gets.gsub(/\+.*/, '') + ' UTC' } if exists_internally?
    rescue
    end
    last_commit_at_time
  end
  
  def create_internal
    return true if not use_internal? or exists_internally?

    # Create the repo, create the permissions file, create the site file, enable the site file, and reload the apache config.
    conn = open_conn
    run_cmd_str("sudo -u www-data svnadmin create #{REPO_PATH}/#{key}", 'Error creating repository!', conn)
    create_file(self.project.is_private? ? apache_repo_private_perm_file : apache_repo_public_perm_file, apache_repo_perm_filepath, conn)
    create_apache_site_file(apache_site_file, apache_site_file_name, conn)
    enable_apache_site_file(apache_site_file_name, conn)     
    reload_apache_config(conn)
    close_conn(conn)
    true
  end  
  
  def reset_perm_file(make_private)
    conn = open_conn
    create_file(make_private ? apache_repo_private_perm_file : apache_repo_public_perm_file, apache_repo_perm_filepath)
    reload_apache_config(conn)
    close_conn(conn)
    true
  end
  
  private
  
  def key
    self.project.shortname.downcase
  end
  
  def repo_path
    "#{REPO_PATH}/#{key}"
  end
  
  def apache_repo_public_perm_file
    "[/]\n* =\n@registered-users = r\n@forge-#{key}-admins = rw\n@forge-#{key}-members = rw"
  end

  def apache_repo_private_perm_file
    "[/]\n* =\n@forge-#{key}-admins = rw\n@forge-#{key}-members = rw"
  end

  def apache_repo_perm_filepath
    "#{APACHE_REPO_PERMS_PATH}/#{key}.#{APACHE_REPO_PERMS_EXT}"
  end

# Change line below to
#  <Location /forge/svn/#{key}>

  def apache_site_file
<<eos
<Location /forge/svn/#{key}>

  DAV svn

  SVNPath #{repo_path}

  AuthType Basic
  AuthName "FUSE Forge Repository"

  PerlAuthenHandler Apache::CrowdAuth
  PerlSetVar CrowdAppName ruby
  PerlSetVar CrowdAppPassword password
  PerlSetVar CrowdSOAPURL http://#{CROWD_HOST}:8095/crowd/services/SecurityServer

  PerlAuthzHandler Apache::CrowdAuthz
  PerlSetVar CrowdAuthzSVNAccessFile #{apache_repo_perm_filepath}

  require valid-user

</Location>
eos
  end

  def apache_site_file_name
    "#{APACHE_SITE_PREFIX}#{key}"
  end
end