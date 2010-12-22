# ===========================================================================
# Copyright (C) 2009, Progress Software Corporation and/or its 
# subsidiaries or affiliates.  All rights reserved.
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ===========================================================================

require 'command_executor'
require 'nexus'

class WebDavLocation < ActiveRecord::Base
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
    project.deploy if use_internal_changed?
  end
  
  def before_destroy
    # return true unless exists_internally?
    # Disable the apache site file, reload the apache config, delete the apache site file, and delete the webdav directory.
    # conn = open_conn
    # disable_apache_site_file(apache_site_file_name, conn)     
    # reload_apache_config(conn)
    # remove_apache_site_file(apache_site_file_name, conn)
    # remove_directory(webdav_collection_path, conn)
    # close_conn(conn)
    true
  end
    
  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def internal_url
    "#{FORGE_URL}/dav/#{key}"
  end  
    
  def website_url
    if use_internal?
       PROJECT_HOMEPAGE_PATTERN.gsub("@PROJECT@", key) 
    else
      nil
    end  
  end    
  
  def url
    use_internal? ? internal_url : external_url
  end

  def create_internal(reload=true)
    return true unless use_internal?
    
    apache_user = DAV_CONFIG[:user]
    
    # if DAV_CONFIG[:ssh] is nil, then commands are run locally 
    CommandExecutor.open(DAV_CONFIG[:ssh]) do |x|

      if !x.dir_exists?(repo_filepath) 
        x.system("mkdir -p #{repo_filepath}", apache_user)
        x.system("mkdir -p #{repo_filepath}/site", apache_user)
        x.system("mkdir -p #{repo_filepath}/download", apache_user)
        x.write(external_site_index_file, "#{repo_filepath}/index.html", apache_user) 
      end

      x.write(apache_dav_file, "#{DAV_ROOT}/httpd.conf/default-virtualhost/#{key}")==0 or raise 'Error creating apache conf file!'
      x.write(apache_site_file, "#{DAV_ROOT}/httpd.conf/sites/#{key}")==0 or raise 'Error creating apache conf file!'  
      
      if reload
        x.system('/etc/init.d/apache2 reload', "root")==0 or raise 'Error reloading apache config!'
      end
    
    end
    
    # Now ask nexus to this project to deploy to it:
    deploy_nexus_config
    true
    
  end 
  
  #
  # One day perhaps this should move to it's own class so that
  # uses can disable web dav but enable nexues support.  But for now,
  # web dav support implies nexus support.
  #
  def deploy_nexus_config
    Nexus.open(NEXUS_CONFIG[:url]) do |nexus|
      group_id = "org.fusesource.#{key}"
  
      #
      # Setup the repo target
      #
      target_id = nexus.get_repo_targets_by_name[group_id]
      if( target_id == nil )
        puts "creating the repo target"
        target_id = nexus.post_repo_target("name"=>group_id, "patterns"=>[".*/org/fusesource/#{key}/.*"])["id"]
      end

      #
      # Setup the staging profile
      #
      staging_rule_set_id = nexus.get_staging_rule_sets_by_name["Maven Central Sync Validation"]
      staging_profile_id = nexus.get_staging_profile_by_name[group_id]
      if( !staging_profile_id ) 
        staging_profile = {
            "name"=>group_id,
            "repositoryTargetId"=>target_id,
            "promotionTargetRepository"=>"releases-to-central",
            "closeRuleSets"=>[staging_rule_set_id]
        }
        staging_profile_id = nexus.post_staging_profile(staging_profile)["id"]
      end
  
      #
      # Setup the repo target permissions
      #
      privileges_by_name = nexus.get_privileges_by_name;
      names = ["create","read", "update", "delete"].collect {|x| "#{group_id} - all - (#{x})"}
      privilege_ids = privileges_by_name.values_at(*names).compact
      if( privilege_ids.length !=4 )
        privilege_ids.each {|x| nexus.delete_privilege(x)}
        nexus.post_privileges_target("name"=>"#{group_id} - all", 
            "repositoryTargetId"=>target_id,
            "description"=>"#{group_id} - all").inspect
      end
  
      names = ["create","read", "update", "delete"].collect {|x| "#{group_id} - snapshots - (#{x})"}
      privilege_ids = privileges_by_name.values_at(*names).compact
      if( privilege_ids.length !=4 )
        privilege_ids.each {|x| nexus.delete_privilege(x)}
        nexus.post_privileges_target("name"=>"#{group_id} - snapshots", 
            "repositoryTargetId"=>target_id,
            "repositoryId"=>"snapshots",
            "description"=>"#{group_id} - snapshots").inspect
      end
  
      #
      # Setup the role for members.
      #
      roles_by_name = nexus.get_roles_by_name
      privileges_by_name = nexus.get_privileges_by_name;
      
      roles = []
      roles << roles_by_name["Staging: Deployer (#{group_id})"]
      roles << roles_by_name["Nexus Developer Role"]
      roles << roles_by_name["UI: Staging Repositories"]
      roles << roles_by_name["Repo: All Repositories (Read)"]
  
      privileges = []
      privileges << privileges_by_name["#{group_id} - all - (create)"]
      privileges << privileges_by_name["#{group_id} - all - (read)"]
      privileges << privileges_by_name["#{group_id} - all - (update)"]
      privileges << privileges_by_name["#{group_id} - snapshots - (delete)"]
      privileges << privileges_by_name["Staging: Profile #{group_id} - (promote)"]
  
      role_id = "forge-#{key}-members"
      role = {"id"=>role_id,"name"=>role_id,
          "description"=>"Forge Role: #{role_id}",
          "sessionTimeout"=>60,"roles"=>roles,"privileges"=>privileges}
      
      if( roles_by_name[role_id] ) 
        nexus.put_role(role)
      else 
        nexus.post_role(role)
      end

      #
      # Setup the role for admins.
      #
      role_id = "forge-#{key}-admins"
      role = {"id"=>role_id,"name"=>role_id,
          "description"=>"Forge Role: #{role_id}",
          "sessionTimeout"=>60,"roles"=>["forge-#{key}-members"]}
      if( roles_by_name[role_id] ) 
        nexus.put_role(role)
      else 
        nexus.post_role(role)
      end
    end 
    
  end
  
  def update_permissions
    return true unless use_internal?
    
    CommandExecutor.open(DAV_CONFIG[:ssh]) do |x|
      x.write(apache_dav_file, "#{DAV_ROOT}/httpd.conf/default-virtualhost/#{key}")==0 or raise 'Error creating apache conf file!'
      x.write(apache_site_file, "#{DAV_ROOT}/httpd.conf/sites/#{key}")==0 or raise 'Error creating apache conf file!'  
      x.system('/etc/init.d/apache2 reload', "root")==0 or raise 'Error reloading apache config!'
    end
    true
    
  rescue => error
    logger.error """Error updating web dav permissions: #{error}\n#{error.backtrace.join("\n")}"""    
  end
  
  private
  
  def key
    self.project.key
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
    Options Indexes MultiViews FollowSymlinks
    AllowOverride FileInfo
    Order allow,deny
    allow from all
    <Files ~ "^\.ht">
      Order deny,allow
      Allow from all
    </Files>
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
    PerlSetVar CrowdCacheEnabled on
    PerlSetVar CrowdCacheLocation #{DAV_ROOT}/crowd-cache/#{key}
    PerlSetVar CrowdCacheExpiry 300
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
    PerlSetVar CrowdCacheEnabled on
    PerlSetVar CrowdCacheLocation #{DAV_ROOT}/crowd-cache/#{key}
    PerlSetVar CrowdCacheExpiry 300
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
    Options Indexes MultiViews FollowSymlinks
    AllowOverride FileInfo
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
    PerlSetVar CrowdCacheEnabled on
    PerlSetVar CrowdCacheLocation #{DAV_ROOT}/crowd-cache/#{key}
    PerlSetVar CrowdCacheExpiry 300
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
