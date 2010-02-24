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

namespace :friendly_id do
  desc "Make slugs for a model."
  task :make_slugs => :environment do
    raise 'USAGE: rake friendly_id:make_slugs MODEL=MyModelName' if ENV["MODEL"].nil?
    if !sluggable_class.friendly_id_options[:use_slug]
      raise "Class \"#{sluggable_class.to_s}\" doesn't appear to be using slugs"
    end
    while records = sluggable_class.find(:all, :include => :slugs, :conditions => "slugs.id IS NULL", :limit => 1000) do
      break if records.size == 0
      records.each do |r|
        r.send(:set_slug)
        r.save!
        puts "#{sluggable_class.to_s}(#{r.id}) friendly_id set to \"#{r.slug.name}\""
      end
    end
  end

  desc "Regenereate slugs for a model."
  task :redo_slugs => :environment do
    raise 'USAGE: rake friendly_id:redo_slugs MODEL=MyModelName' if ENV["MODEL"].nil?
    if !sluggable_class.friendly_id_options[:use_slug]
      raise "Class \"#{sluggable_class.to_s}\" doesn't appear to be using slugs"
    end
    Slug.destroy_all(["sluggable_type = ?", sluggable_class.to_s])
    Rake::Task["friendly_id:make_slugs"].invoke
  end

  desc "Kill obsolete slugs older than 45 days."
  task :remove_old_slugs => :environment do
    if ENV["DAYS"].nil?
      @days = 45
    else
      @days = ENV["DAYS"].to_i
    end
    slugs = Slug.find(:all, :conditions => ["created_at < ?", DateTime.now - @days.days])
    slugs.each do |s|
      s.destroy if !s.is_most_recent?
    end
  end
end

def sluggable_class
  if (ENV["MODEL"].split('::').size > 1)
    ENV["MODEL"].split('::').inject(Kernel) {|scope, const_name| scope.const_get(const_name)}
  else
    Object.const_get(ENV["MODEL"])
  end
end