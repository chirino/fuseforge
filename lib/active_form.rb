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

# This class allows one to leverage the goodness of the ActiveRecord class
# without a database table having to back it up. Simply inherit this class
# and add some columns like so:
# 
#   class MyForm < ActiveForm
#     column(:name, :string)
#     column(:dob, :date)
#     column(:active, :boolean)
#   end
#   
#   Idea borrowed from http://www.railsweenie.com/forums/2/topics/724
class ActiveForm < ActiveRecord::Base
  def self.columns()
    @columns ||= []
  end
  
  def self.column(name, sql_type = nil, default = nil, null = true)
    columns << ActiveRecord::ConnectionAdapters::Column.new(name.to_s, default, sql_type.to_s, null)
  end
end
