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

module ProjectsHelper
  def search_select_options_for_project_status
    current_user.is_site_admin? ? ProjectStatus.options_for_select : ProjectStatus.options_for_select_approved
  end
  
  def truncate(text, length = 30, end_string = '...')
    return "" if text == nil
    words = text.split()
    words[0..(length-1)].join(' ') + (words.length > length ? end_string : '')
  end

  def category_cloud
    cats = ProjectCategory.all
    classes = @levels
    max_count = cats.sort_by(&:count).last.count.to_f
    cats.each do |cat|
      index = ((cat.count / max_count) * (classes.size - 1)).round
      yield cat, classes[index]
    end
  end

end


