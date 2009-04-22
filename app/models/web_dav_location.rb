class WebDavLocation < ActiveRecord::Base
  include ApacheConfigMixins
  
  belongs_to :project
  
  DAV_ROOT = '/var/forge/dav'
  
  def repo_filepath
    "#{DAV_ROOT}/repos/#{key}"
  end
  
  def dav_prefix
    "/forge/dav"
  end

  def site_prefix
    "/forge/sites"
  end
  
  def before_save
    self.external_url = '' if use_internal?
  end
  
  def before_destroy
    return true unless exists_internally?
    
    # Disable the apache site file, reload the apache config, delete the apache site file, and delete the webdav directory.
    # conn = open_conn
    # disable_apache_site_file(apache_site_file_name, conn)     
    # reload_apache_config(conn)
    # remove_apache_site_file(apache_site_file_name, conn)
    # remove_directory(webdav_collection_path, conn)
    # close_conn(conn)
    true
  end
  
  def after_update
    create_internal
  end
  
  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def exists_internally?
    path_exists?("#{repo_filepath}")
  end  
  
  def internal_url
    "#{FORGE_URL}#{dav_prefix}/#{key}"
  end  
  
  def internal_files_url
    "#{FORGE_URL}#{site_prefix}/#{key}/download"
  end  
  
  def website_url
    if use_internal?
       "#{FORGE_URL}#{site_prefix}/#{key}"
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
    
  def create_internal(reload=true)
    return true if not use_internal?
    
    conn = open_conn

    if !remote_dir_exists?(conn, repo_filepath) 
      remote_system(conn, "mkdir -p #{repo_filepath}", APACHE_USER)
      remote_system(conn, "mkdir -p #{repo_filepath}/site", APACHE_USER)
      remote_system(conn, "mkdir -p #{repo_filepath}/download", APACHE_USER)
      remote_write(conn, external_site_index_file, "#{repo_filepath}/index.html", APACHE_USER) 
    end

    remote_write(conn, apache_dav_file, "#{DAV_ROOT}/httpd.conf/default-virtualhost/#{key}")==0 or raise 'Error creating apache conf file!'
    remote_write(conn, apache_site_file, "#{DAV_ROOT}/httpd.conf/sites/#{key}")==0 or raise 'Error creating apache conf file!'  
      
    if reload
      remote_system(conn, '/etc/init.d/apache2 reload', "root")==0 or raise 'Error reloading apache config!'
    end
    
    true
    
  rescue => error
    puts "Error creating the web dav directory: #{error}"
    print error.backtrace.join("\n")
    logger.error "Error creating the web dav directory: #{error}"    
  ensure
    close_conn(conn)
  end  
  
  private
  
  def key
    self.project.shortname.downcase
  end
  
  def apache_write_groups
    groups = "#{CrowdGroup.forge_admin_group.name}"
    self.project.admin_groups.each do |group|
      groups += ",#{group.name}"
    end
    self.project.member_groups.each do |group|
      groups += ",#{group.name}"
    end
    return groups
  end

  def apache_dav_file
    rc = <<EOF
  Alias #{dav_prefix}/#{key} #{repo_filepath}
  <Directory #{repo_filepath}/>
    Options Indexes MultiViews
    AllowOverride None
    Order allow,deny
    allow from all 
  </Directory>  
  <Location #{dav_prefix}/#{key}>
    Dav On
    AuthType Basic
    AuthName "FUSE Source Login"
    PerlAuthenHandler Apache::CrowdAuth
    PerlSetVar CrowdAppName ruby
    PerlSetVar CrowdAppPassword password
    PerlSetVar CrowdSOAPURL #{CROWD_URL}/services/SecurityServer
    PerlAuthzHandler Apache::CrowdAuthz
    PerlSetVar CrowdAllowedGroups #{apache_write_groups}
    require valid-user
  </Location>
  
  #
  # Allowing external users to push http files from our domain
  # could open a XSS security hole.. perhaps we should eleminate this and
  # only serve that site from the $project.fusesource.org domain.
  # 
  Alias #{site_prefix}/#{key} #{repo_filepath}
EOF

    if self.project.is_private
      b = <<EOF
  <Location #{site_prefix}/#{key}>
    Dav On
    AuthType Basic
    AuthName "FUSE Source Login"
    PerlAuthenHandler Apache::CrowdAuth
    PerlSetVar CrowdAppName ruby
    PerlSetVar CrowdAppPassword password
    PerlSetVar CrowdSOAPURL #{CROWD_URL}/services/SecurityServer
    PerlAuthzHandler Apache::CrowdAuthz
    PerlSetVar CrowdAllowedGroups #{apache_write_groups}
    require valid-user
  </Location>
EOF
      rc += b;
    end
    return rc
  end

  def apache_site_file
    rc = <<EOF
<VirtualHost *>
  ServerName #{key}.fusesource.org
  DocumentRoot #{repo_filepath}
  <Directory #{repo_filepath}/>
    Options Indexes MultiViews
    AllowOverride None
    Order allow,deny
    allow from all 
  </Directory> 
EOF
  
    if self.project.is_private
      b = <<EOF
  <Location />
    AuthType Basic
    AuthName "FUSE Source Login"
    PerlAuthenHandler Apache::CrowdAuth
    PerlSetVar CrowdAppName ruby
    PerlSetVar CrowdAppPassword password
    PerlSetVar CrowdSOAPURL #{CROWD_URL}/services/SecurityServer
    PerlAuthzHandler Apache::CrowdAuthz
    PerlSetVar CrowdAllowedGroups #{apache_write_groups}
    require valid-user
  </Location>
EOF
      rc += b;
    end
    b = <<EOF
</VirtualHost>
EOF
    rc += b;
    return rc;
  end
  
  def external_site_index_file
    rc = <<EOF
  <h1>#{project.name}</h1>
  <a href=\"#{project.internal_url}\">Project Page</a>
EOF
    return rc;
  end
end
