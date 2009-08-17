require 'confluence/confluence.rb'
require 'benchmark_http_requests'
require 'set'

#
# Make it so a Hash can be a keyed
#
module HashedKey
  def eql?(other)
    self == other
  end

  def hash
    rc=0
    keys.each do |x|
      rc |= x.hash
    end
    values.each do |x|
      rc |= x.hash
    end
    rc
  end
end
    
class Wiki < ActiveRecord::Base
  belongs_to :project
  serialize :last_permissions

  def before_save
    self.external_url = '' if use_internal?
    project.deploy if use_internal_changed?
  end
  
  def before_destroy
    # Confluence.open(CONFLUENCE_CONFIG) do |confluence|
    #   return true unless confluence.space_exist?(key)
    #   confluence.remove_space(key)   
    # end
  end
  
  def is_active?
    use_internal? or not external_url.blank?
  end
  
  def url
    use_internal? ? internal_url : external_url
  end

  def internal_url
    "#{CONFLUENCE_CONFIG[:url]}/display/#{key}/Home"
  end  
  
  def create_internal
    return true if not use_internal?
    
    Confluence.open(CONFLUENCE_CONFIG) do |confluence|
      
      # create the space.
      space = confluence.get_space(key)
      unless space
        logger.info "adding space"
        confluence.add_space(key, {:name=>"Forge: #{project.name}", :description=>project.description})
      else
        logger.info "got #{space.description}"
        space.name="Forge: #{project.name}"
        space.description=project.description
        logger.info "made it #{space.description}"
        confluence.store_space(space)
      end
      
      reset_permissions(confluence)
      
    end
  end

  def all_permissions
    rc = []
    [:read, :write, :admin].each do |perm|
      rc << { :perm=>perm, :key=>key }
      member_groups.each do |group|
        rc << ( { :perm=>perm, :key=>key, :subject=>group }.extend HashedKey )
      end
      admin_groups.each do |group|
        rc << ( { :perm=>perm, :key=>key, :subject=>group }.extend HashedKey )
      end
    end
    rc.to_set
  end
  
  private 
  
  def key 
    project.shortname.upcase
  end
  
  def admin_groups
    groups = [ CrowdGroup.forge_admin_group.name ]
    project.admin_groups.each do |group|
        groups << group.name
    end
    groups
  end
  
  def member_groups
    groups = []
    project.member_groups.each do |group|
        groups << group.name
    end
    groups
  end

  def next_permissions
    rc = []
    if !project.is_private
      rc << ({ :perm=>:read, :key=>key }.extend HashedKey)
    end
    member_groups.each do |group|
      rc << ({ :perm=>:read, :key=>key, :subject=>group }.extend HashedKey)
      rc << ({ :perm=>:write, :key=>key, :subject=>group }.extend HashedKey)
    end
    admin_groups.each do |group|
      rc << ({ :perm=>:read, :key=>key, :subject=>group }.extend HashedKey)
      rc << ({ :perm=>:write, :key=>key, :subject=>group }.extend HashedKey)
      rc << ({ :perm=>:admin, :key=>key, :subject=>group }.extend HashedKey)
    end
    rc.to_set
  end

  def reset_permissions(confluence)
    
    perms_map = { 
      :read=>["VIEWSPACE"],
      :write=>["EDITSPACE", "COMMENT", "REMOVEPAGE", "REMOVECOMMENT", "REMOVEBLOG", "CREATEATTACHMENT", "REMOVEATTACHMENT", "EDITBLOG", "EXPORTPAGE", "SETPAGEPERMISSIONS"],
      :admin=>["SETSPACEPERMISSIONS", "EXPORTSPACE", "REMOVEMAIL", "SETPAGEPERMISSIONS"]
    }
    
    perms_old = last_permissions || [].to_set
    perms_new = next_permissions
    to_remove = perms_old - perms_new

    #
    # Remove the old perms that are no longer needed.
    to_remove.each do |p|
      perms_map[p[:perm]].each do |perm|
        if p[:subject]
          safe_remove_permission_from_space(confluence, p[:key], perm, p[:subject])
        else
          safe_remove_permission_from_space(confluence, p[:key], perm)
        end
      end
    end
    
    #
    # Add the new perms..
    perms_new.each do |p|
      perms_map[p[:perm]].each do |perm|
        if p[:subject]
          confluence.add_permission_to_space(p[:key], perm, p[:subject])
        else
          confluence.add_permission_to_space(p[:key], perm)
        end
      end
    end
    
    last_permissions = perms_new
    save
  end

  def safe_remove_permission_from_space(confluence, key, perm, subject=nil)
    confluence.remove_permission_from_space(key, perm, subject)
  rescue => error
    logger.info """Could not remove permission: #{key}, #{perm}, #{subject}: #{error}"""
  end


end
