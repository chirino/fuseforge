if ActiveRecord::Base.configurations["phpbb"]
  class PhpbbAclRole < ActiveRecord::Base
    establish_connection "phpbb"
    set_table_name "phpbb_acl_roles"
    set_primary_key "role_id"
  
    FORUM_NOACCESS = 16
    FORUM_READONLY = 17
    FORUM_BOT      = 19
    FORUM_STANDARD = 15
    FORUM_FULL     = 14
    FORUM_POLLS    = 21
    MOD_FULL       = 10
  end
end