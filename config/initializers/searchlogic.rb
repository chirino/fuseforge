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

# Registers a condition as an available condition for a column or a class. MySQL supports a "sounds like" function. I want to use it, so let's add it.
#
# === Example
#
#   # config/initializers/searchlogic.rb
#   # Actual function for MySQL databases only
#   class SoundsLike < Searchlogic::Condition::Base
#     # The name of the conditions. By default its the name of the class, if you want alternate or alias conditions just add them on.
#     # If you don't want to add aliases you don't even need to define this method
#     def self.condition_names_for_column(column)
#       super + ["similar_to", "sounds"]
#     end
#
#     # You can return an array or a string. NOT a hash, because all of these conditions
#     # need to eventually get merged together. The array or string can be anything you would put in
#     # the :conditions option for ActiveRecord::Base.find(). Also notice the column_sql variable. This is essentail
#     # for applying modifiers and should be used in your conditions wherever you want the column.
#     def to_conditions(value)
#       ["#{column_sql} SOUNDS LIKE ?", value]
#     end
#   end
#
#   Searchlogic::Conditions::Base.register_condition(SoundsLike)

class KeywordsUsingOr < Searchlogic::Condition::Base
  # Because be default it joins with AND, so padding an array just gives you more options. Joining with and is no different than 
  # combining all of the words.

  self.join_arrays_with_or = true
  
  BLACKLISTED_WORDS = ('a'..'z').to_a + ["about", "an", "are", "as", "at", "be", "by", "com", "de", "en", "for", "from", "how", "in", "is", "it", "la", "of", "on", "or", "that", "the", "the", "this", "to", "und", "was", "what", "when", "where", "who", "will", "with", "www"] # from ranks.nl        
  FOREIGN_CHARACTERS = 'àáâãäåßéèêëìíîïñòóôõöùúûüýÿ'
  
  class << self
    def condition_names_for_column
      super + ["kwords_using_or", "kw_using_or"]
    end
  end
  
  def to_conditions(value)
    strs = []
    subs = []
    
    search_parts = value.gsub(/,/, " ").split(/ /)
    replace_non_alnum_characters!(search_parts)
    search_parts.uniq!
    remove_blacklisted_words!(search_parts)
    return if search_parts.blank?
    
    search_parts.each do |search_part|
      strs << "#{column_sql} #{like_condition_name} ?"
      subs << "%#{search_part}%"
    end
    
    [strs.join(" OR "), *subs]
  end
  
  private
    def replace_non_alnum_characters!(search_parts)
      search_parts.each do |word|
        word.downcase!
        word.gsub!(/[^[:alnum:]#{FOREIGN_CHARACTERS}]/, '')
      end
    end
    
    def remove_blacklisted_words!(search_parts)
      search_parts.delete_if { |word| word.blank? || BLACKLISTED_WORDS.include?(word.downcase) }
    end
end

Searchlogic::Conditions::Base.register_condition(KeywordsUsingOr)
