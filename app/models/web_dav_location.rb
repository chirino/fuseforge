class WebDavLocation < ActiveRecord::Base
  include ApacheConfigMixins
  
  belongs_to :project
  
  INTERNAL_HOST = Socket.gethostname == 'dude' ? 'fusesource.com' : 'fusesourcedev.com'
  WEBDAV_PATH = '/var/dav'
  
  SITE_DIR_NAME = 'site'
  SITES_DIR_NAME = 'sites'
  FILES_DIR_NAME = 'files'
  DOWNLOAD_DIR_NAME = 'download'

  APACHE_ALIAS_PREFIX = 'forge/dav/'
  APACHE_FILES_ALIAS_PREFIX = "forge/#{FILES_DIR_NAME}/"
  APACHE_SITES_ALIAS_PREFIX = "forge/#{SITES_DIR_NAME}/"
  APACHE_SITE_PREFIX = 'dav_'
  WEBSITE_URL_PREFIX = "http://#{INTERNAL_HOST}/forge/#{SITES_DIR_NAME}"

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
  
  def after_update
    create_internal
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
  
  def internal_files_url
    "http://#{INTERNAL_HOST}/#{files_alias}"
  end  
  
  def website_url
    if use_internal?
       "#{WEBSITE_URL_PREFIX}/#{project.shortname.downcase}/"
    else
      nil
    end  
  end    
  
  def url
    use_internal? ? internal_url : external_url
  end

  def files_url
    use_internal? ? internal_files_url : external_url
  end
    
  def create_internal
    return true if not use_internal? or exists_internally?
    
    # Disable the apache site file, reload the apache config, delete the apache site file, and delete the webdav directory.
    # Create the webdav directory, create the apache site file, enable the apache site file, and reload the apache config
    conn = open_conn
    create_directory(webdav_collection_path, conn)
    create_directory(webdav_collection_site_path, conn)
    create_directory(webdav_collection_download_path, conn)
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
    "#{webdav_collection_path}/#{SITE_DIR_NAME}"
  end
  
  def webdav_collection_download_path
    "#{webdav_collection_path}/#{DOWNLOAD_DIR_NAME}"
  end
  
  def webdav_alias
    "#{APACHE_ALIAS_PREFIX}#{key}"
  end  
  
  def files_alias
    "#{APACHE_FILES_ALIAS_PREFIX}#{key}"
  end  
  
  def sites_alias
    "#{APACHE_SITES_ALIAS_PREFIX}#{key}"
  end  
  
  def apache_site_file
<<eos
  <Directory #{webdav_collection_path}/>
    Options Indexes MultiViews
    AllowOverride None
    Order allow,deny
    allow from all 
  </Directory>
  
  Alias /#{files_alias} #{webdav_collection_path}
  Alias /#{sites_alias} #{webdav_collection_path}/#{SITE_DIR_NAME}

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

  <Directory #{webdav_collection_path}/#{DOWNLOAD_DIR_NAME}>
    Options Indexes MultiViews
    AllowOverride None
    Order allow,deny
    allow from all 
  </Directory>
  
  Alias /#{webdav_alias}/download #{webdav_collection_path}/#{DOWNLOAD_DIR_NAME}
  <Location /#{webdav_alias}/#{DOWNLOAD_DIR_NAME}>
    Dav On
    AuthType Basic
    AuthName "FUSE Forge Webdav"
    PerlAuthenHandler Apache::CrowdAuth
    PerlSetVar CrowdAppName ruby
    PerlSetVar CrowdAppPassword password
    PerlSetVar CrowdSOAPURL http://#{CROWD_HOST}:8095/crowd/services/SecurityServer
    PerlAuthzHandler Apache::CrowdAuthz
    PerlSetVar CrowdAllowedGroups #{SiteAdminGroup.new.name},#{project.default_admin_group_name}
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
