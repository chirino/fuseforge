class WebDavLocation < ActiveRecord::Base
  include ApacheConfigMixins
  
  belongs_to :project
  
  INTERNAL_HOST = Socket.gethostname == 'dude' ? 'fusesource.com' : 'fusesourcedev.com'
  WEBDAV_PATH = '/var/dav'

  APACHE_ALIAS_PREFIX = 'forge/dav/'
  APACHE_SITE_PREFIX = 'dav_'

  def before_save
    self.external_url = '' if use_internal?
  end
  
  def before_destroy
    return true unless exists_internally?
    
    # Disable the apache site file, reload the apache config, delete the apache site file, and delete the webdav directory.
    conn = open_conn
    disable_apache_site_file(apache_site_file_name, conn)     
    reload_apache_config(conn)
    remove_apache_site_file(apache_site_file_name, conn)
    remove_directory(webdav_collection_path, conn)
    close_conn(conn)
    true
  end
  
  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def exists_internally?
    path_exists?(webdav_collection_path)
  end  
  
  def internal_url
    "http://#{INTERNAL_HOST}/#{webdav_alias}"
  end  
  
  def url
    use_internal? ? internal_url : external_url
  end
  
  def create_internal
    return true if not use_internal? or exists_internally?
    
    # Disable the apache site file, reload the apache config, delete the apache site file, and delete the webdav directory.
    # Create the webdav directory, create the apache site file, enable the apache site file, and reload the apache config
    conn = open_conn
    create_directory(webdav_collection_path, conn)
    create_directory(webdav_collection_site_path, conn)
    run_cmd_str("sudo chmod -R g+w #{webdav_collection_site_path}", 'Error chmoding webdav website dir!', conn)
    create_file(external_site_index_file, "#{webdav_collection_site_path}/index.html", conn)
    chown_dir("#{webdav_collection_path}/")
    create_apache_site_file(apache_site_file, apache_site_file_name, conn)
    enable_apache_site_file(apache_site_file_name, conn)
    reload_apache_config(conn)
    close_conn(conn)
    true
  end  
  
  private
  
  def key
    self.project.shortname.downcase
  end
  
  def webdav_collection_path
    "#{WEBDAV_PATH}/#{key}"
  end
  
  def webdav_collection_site_path
    "#{webdav_collection_path}/site"
  end
  
  def webdav_alias
    "#{APACHE_ALIAS_PREFIX}#{key}"
  end  
  
  def apache_site_file
<<eos
  <Directory #{webdav_collection_path}/>
    Options Indexes MultiViews
    AllowOverride None
    Order allow,deny
    allow from all 
  </Directory>

  Alias /#{webdav_alias} #{webdav_collection_path}
  <Location /#{webdav_alias}>
    Dav On
    AuthType Basic
    AuthName "FUSE Forge Webdav"
    PerlAuthenHandler Apache::CrowdAuth
    PerlSetVar CrowdAppName ruby
    PerlSetVar CrowdAppPassword password
    PerlSetVar CrowdSOAPURL http://#{CROWD_HOST}:8095/crowd/services/SecurityServer
    PerlAuthzHandler Apache::CrowdAuthz
    PerlSetVar CrowdAllowedGroups #{SiteAdminGroup.new.name},#{project.default_admin_group_name},#{project.default_member_group_name}
    require valid-user
  </Location>
eos
  end

  def apache_site_file_name
    "#{APACHE_SITE_PREFIX}#{key}"
  end
  
  def external_site_index_file
<<eos
  <h1>#{project.name}</h1>
  <a href=\"#{project.internal_url}\">Project Page</a>
eos
  end
end
