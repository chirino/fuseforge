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
require 'rubygems'
require 'rest_client'
require 'json'

class Nexus
    
  def self.open(config, &block)
    rc = Nexus.new(config)
    if( block ) 
      begin
        return block.call(rc)
      ensure
        rc.close
      end
    else
      return rc
    end
  end

  def initialize(config)
    @config = config
  end
  
  def close
  end 

private
    
  def url_base
    "#{@config[:url]}/service/local"
  end
  
  def dc    
    "_dc=#{Time.now.to_i}"
  end 

  def get(url, headers={}, &block)
    headers = {:content_type => :json, :accept => :json}.merge(headers)
    from_json(RestClient.get(url, headers, &block))
  end
  def delete(url, headers={}, &block)
    headers = {:content_type => :json, :accept => :json}.merge(headers)
    from_json(RestClient.delete(url, headers, &block))
  end
  def post(url, data, headers={}, &block)
    headers = {:content_type => :json, :accept => :json}.merge(headers)
    from_json(RestClient.post(url, to_json(data), headers, &block))
  end
  def put(url, data, headers={}, &block)
    headers = {:content_type => :json, :accept => :json}.merge(headers)
    from_json(RestClient.put(url, to_json(data), headers, &block))
  end
  
  def from_json(value)
    if value == nil || value.empty?
      nil
    else
      JSON.parse value
    end
  end
  
  def to_json(value)
    if value == nil
      ""
    else
      value.to_json
    end
  end
  
public

  def status    
    get "#{url_base}/status?#{dc}"
  end 

  def login
    get "#{url_base}/authentication/login?#{dc}"
  end 
  
  # ===================================================================
  # repositories access
  # ===================================================================
  def get_repositories
    get("#{url_base}/repositories?#{dc}")["data"]
  end 
  def get_repositories_by_name
    Hash[ *get_repositories.collect {|x| [x["name"], x["id"]] }.flatten ]
  end 

  # ===================================================================
  # repo_targets access
  # ===================================================================
  def post_repo_target(repo_target)
    repo_target= {
      "name"=>nil, 
      "contentClass"=>"maven2", 
      "patterns"=>[]
    }.merge(repo_target)
    request = {"data"=>repo_target}
    post("#{url_base}/repo_targets", request)["data"]
  end 
  def get_repo_targets
    get("#{url_base}/repo_targets?#{dc}")["data"]
  end 
  def get_repo_targets_by_name
    Hash[ *get_repo_targets.collect {|x| [x["name"], x["id"]] }.flatten ]
  end 
  def delete_repo_target(id)
    delete "#{url_base}/repo_targets/#{id}"
  end 

  # ===================================================================
  # privileges access
  # ===================================================================
  def post_privileges_target(privileges_targe)
    privileges_targe = {
      "name"=>nil, 
      "repositoryTargetId"=>nil,
      "description"=>"", 
      "repositoryId"=>"",
      "repositoryGroupId"=>"",
      "method"=>["create","read","update","delete"],
      "type"=>"target"
    }.merge(privileges_targe);
    request = {"data"=>privileges_targe}
    post("#{url_base}/privileges_target", request)["data"]
  end 
  def get_privileges
    get("#{url_base}/privileges?#{dc}")["data"]
  end 
  def get_privileges_by_name
    Hash[ *get_privileges.collect {|x| [x["name"], x["id"]] }.flatten ]
  end 
  def delete_privilege(id)
    puts "deleting priv: #{id}"
    delete "#{url_base}/privileges/#{id}"
  end 

  # ===================================================================
  # staging_profile access
  # ===================================================================
  def post_staging_profile(staging_profile)
    staging_profile = { 
      "name"=>nil,
      "repositoryTargetId"=>nil,
      "promotionTargetRepository"=>nil,
      "repositoryTemplateId"=>"default_hosted_release",
      "repositoryType"=>"maven2",
      "targetGroups"=>["public"],
      "finishNotifyEmails"=>nil,
      "promotionNotifyEmails"=>nil,
      "finishNotifyRoles"=>[],
      "promotionNotifyRoles"=>[],
      "closeRuleSets"=>[],
      "promoteRuleSets"=>[]
    }.merge(staging_profile);
    request = {"data"=>staging_profile}
    post("#{url_base}/staging/profiles?#{dc}", request)["data"]
  end 
  def get_staging_profile
    get("#{url_base}/staging/profiles?#{dc}")["data"]
  end 
  def get_staging_profile_by_name
    Hash[ *get_staging_profile.collect {|x| [x["name"], x["id"]] }.flatten ]
  end 
  def delete_staging_profile(id)
    delete "#{url_base}/staging/profiles/#{id}"
  end 
  
  # ===================================================================
  # staging_rule_set access
  # ===================================================================
  def get_staging_rule_sets
    get("#{url_base}/staging/rule_sets?#{dc}")["data"]
  end 
  def get_staging_rule_sets_by_name
    Hash[ *get_staging_rule_sets.collect {|x| [x["name"], x["id"]] }.flatten ]
  end 

  # ===================================================================
  # role access
  # ===================================================================
  def post_role(role)
    role = {
      "id"=>nil,
      "name"=>nil, 
      "description"=>"", 
      "sessionTimeout"=>"60",
      "roles"=>[],
      "privileges"=>[]
    }.merge(role);
    post("#{url_base}/roles", {"data"=>role})["data"]
  end 
  def put_role(role)
    id = role["id"]
    put("#{url_base}/roles/#{id}", {"data"=>role})["data"]
  end 
  def get_roles
    get("#{url_base}/roles?#{dc}")["data"]
  end 
  def get_roles_by_name
    Hash[ *get_roles.collect {|x| [x["name"], x["id"]] }.flatten ]
  end 
  def delete_role(id)
    puts "deleting priv: #{id}"
    delete "#{url_base}/roles/#{id}"
  end 
    
  # ===================================================================
  # external_role access
  # ===================================================================
  def get_external_roles
    get("#{url_base}/external_role_map/all?#{dc}")["data"]
  end 
  def get_external_roles_by_name
    Hash[ *get_privileges.collect {|x| [x["name"], x["id"]] }.flatten ]
  end 
end

conf = {
  :url => 'http://admin:password@repo.fusesource.com/nexus',
}

Nexus.open(conf) do |nexus|
  project_id = "scalate"
  
  group_id = "org.fusesource.#{project_id}"
  target_id = nexus.get_repo_targets_by_name[group_id]
  if( target_id == nil )
    puts "creating the repo target"
    target_id = nexus.post_repo_target("name"=>group_id, "patterns"=>[".*/org/fusesource/#{project_id}/.*"])["id"]
  end
  puts "repo target id is: #{target_id}"

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
  
  privileges_by_name = nexus.get_privileges_by_name;
  create_id = privileges_by_name["#{group_id} - all - (create)"]
  read_id = privileges_by_name["#{group_id} - all - (read)"]
  update_id = privileges_by_name["#{group_id} - all - (update)"]
  delete_id = privileges_by_name["#{group_id} - all - (delete)"]

  # Do we need to cerate the privileges??
  if( !create_id || !read_id || !update_id )        
    nexus.delete_privilege(create_id) if create_id
    nexus.delete_privilege(read_id) if read_id
    nexus.delete_privilege(update_id) if update_id
    nexus.delete_privilege(delete_id) if delete_id
    
    rc = nexus.post_privileges_target("name"=>"#{group_id} - all", 
        "repositoryTargetId"=>target_id,
        "description"=>"#{group_id} - all").inspect

    privileges_by_name = nexus.get_privileges_by_name;
    delete_id = privileges_by_name["#{group_id} - all - (delete)"]
  end
  # Don't need the delete priv
  nexus.delete_privilege(delete_id) if delete_id
  
  create_id = privileges_by_name["#{group_id} - snapshots - (create)"]
  read_id = privileges_by_name["#{group_id} - snapshots - (read)"]
  update_id = privileges_by_name["#{group_id} - snapshots - (update)"]
  delete_id = privileges_by_name["#{group_id} - snapshots - (delete)"]
  
  if( !delete_id )        
    nexus.delete_privilege(create_id) if create_id
    nexus.delete_privilege(read_id) if read_id
    nexus.delete_privilege(update_id) if update_id
    nexus.delete_privilege(delete_id) if delete_id
    
    snapshot_repo_id = nexus.get_repositories_by_name["Snapshots"]
    puts "snapshot repo id is: #{snapshot_repo_id}"

    rc = nexus.post_privileges_target("name"=>"#{group_id} - snapshots", 
        "repositoryTargetId"=>target_id,
        "repositoryId"=>snapshot_repo_id,
        "description"=>"#{group_id} - snapshots").inspect
        
    privileges_by_name = nexus.get_privileges_by_name;
    create_id = privileges_by_name["#{group_id} - snapshots - (create)"]
    read_id = privileges_by_name["#{group_id} - snapshots - (read)"]
    update_id = privileges_by_name["#{group_id} - snapshots - (update)"]
  end
  # Don't need the these privs
  nexus.delete_privilege(create_id) if create_id
  nexus.delete_privilege(read_id) if read_id
  nexus.delete_privilege(update_id) if update_id
  
  #
  # Create the Role
  #
  roles_by_name = nexus.get_roles_by_name
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
  
  role = {"id"=>"forge-#{project_id}-members","name"=>"forge-#{project_id}-members",
      "description"=>"Forge Role: forge-#{project_id}-members",
      "sessionTimeout"=>60,"roles"=>roles,"privileges"=>privileges}
      
  if( roles_by_name["forge-#{project_id}-members"] ) 
    puts "updating role: #{role.to_json}"
    nexus.put_role(role)
  else 
    puts "creating role: #{role.to_json}"
    nexus.post_role(role)
  end


end 
