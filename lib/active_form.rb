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
