#!/usr/bin/env ruby
require 'rubygems'
gem 'soap4r'
require 'confluence/confluence_defaultDriver.rb'

class Confluence
  
  def initialize(config)
    @config = config
    @confluence = ConfluenceSoapService.new(@config[:url]+"/rpc/soap-axis/confluenceservice-v1")
    # @confluence.options["protocol.http.basic_auth"] << [relm, username, password]    
    @confluence.options["protocol.http.basic_auth"] << @config[:basic_auth] if @config[:basic_auth]
    @token = @confluence.login(@config[:login], @config[:password])    
  end

  def self.open(config, &block)
    rc = Confluence.new(config)
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
  
  def close
    @confluence.logout(@token)
  end
    
  def get_space(name)
    begin
      @confluence.getSpace(@token,name)
    rescue
      return nil
    end
  end
  
  def add_space(space, options={})
    request = RemoteSpace.new
    options.each_pair do |key, value|
      request.send "#{key}=", value
    end
    request.key = space
    @confluence.addSpace(@token, request)
  end
  
  def store_space(space)
    @confluence.storeSpace(@token, space)
  end
  
  def remove_space(space)
    @confluence.removeSpace(@token,space)
  end
  
  def add_permission_to_space(space, perm, subject=nil)
    if subject 
      @confluence.addPermissionToSpace(@token, perm, subject, space)
    else
      @confluence.addAnonymousPermissionToSpace(@token, perm, space) 
    end
  end

  def remove_permission_from_space(space, perm, subject=nil)
    if subject 
      @confluence.removePermissionFromSpace(@token, perm, subject, space)
    else
      @confluence.removeAnonymousPermissionFromSpace(@token, perm, space) 
    end
  end
  
  def pages(space)
    @confluence.getPages(@token, space)
  end
  
  def space_level_permissions
    @confluence.getSpaceLevelPermissions(@token)
  end 

end
