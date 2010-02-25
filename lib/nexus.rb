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

    
  def url_base
    "#{@config[:url]}/service/local"
  end
  
  def dc    
    "_dc=#{Time.now.to_i}"
  end 

  def get(url, headers={}, &block)
    headers = {:content_type => :json, :accept => :json}.merge(headers)
    JSON.parse(RestClient.get(url, headers, &block))
  end
  def post(url, data, headers={}, &block)
    headers = {:content_type => :json, :accept => :json}.merge(headers)
    JSON.parse(RestClient.post(url, data, headers, &block))
  end

  def status    
    get "#{url_base}/status?#{dc}"
  end 


  def login
    get "#{url_base}/authentication/login?#{dc}"
  end 
  
  
  def repo_targets
    get "#{url_base}/repo_targets"
  end 
  
  def repo_targets_by_name
    Hash[ *repo_targets["data"].collect {|x| [x["name"], x["id"]] }.flatten ]
  end 

  // {"data":{"id":null,"name":"org.fusesource.mop","contentClass":"maven2","patterns":[".*/org/fusesource/mop/.*"]}}
  def post_repo_target(name, patterns=[], contentClass="maven2")
    data = {"data"=>{"id"=>null, "name"=>name, "contentClass"=>contentClass, "patterns"=>patterns }}
    post "#{url_base}/repo_targets", data.to_json
  end 

http://repo.fusesource.com/nexus/service/local/repo_targets

end

conf = {
  :url => 'http://admin:password@repo.fusesource.com/nexus',
}

Nexus.open(conf) do |nexus|
  puts nexus.repo_targets_by_name.inspect
  puts nexus.post_repo_target("org.fusesource.scalate", [""]) .inspect
end 
