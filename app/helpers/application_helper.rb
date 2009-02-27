# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

  #IMPORTANT:  If you change this group you should also create the below renamed/changed group into crowd
  #and add it as one of the groups that you can be in to authenticate into crowd.
  #STEP 1.3 in the confluence-crowd integration
  #
  DEFAULT_CONFLUENCE_GROUP = "forge-confluence-users"
  FORGE_ADMINISTRATOR      = "forgeadmin"
  FORGE_ADMINS_GROUP        = "forge-admins"
  FORGE_JIRA_GROUP         = "jira-fuseforge-developers"
    
  def ApplicationHelper.get_default_confluence_group
    DEFAULT_CONFLUENCE_GROUP
  end

  def ApplicationHelper.get_default_confluence_group
    DEFAULT_CONFLUENCE_GROUP
  end

  def ApplicationHelper.get_forge_administrator
    FORGE_ADMINISTRATOR
  end

  def ApplicationHelper.get_forge_admins_group
    FORGE_ADMINS_GROUP
  end

  def ApplicationHelper.get_forge_jira_group
    FORGE_JIRA_GROUP
  end
  
  def ApplicationHelper.get_project_groups(project_sname)
      hsh_groups = Hash.new
      hsh_groups[:admins_grp] = "forge-#{project_sname}-admins".downcase
      hsh_groups[:membrs_grp] = "forge-#{project_sname}-members".downcase
      hsh_groups
  end
  
  # Following methods are from http://unixmonkey.net/?p=20
  
  # Rot13 encodes a string
  def rot13(string)
    string.tr "A-Za-z", "N-ZA-Mn-za-m"
  end

  # HTML encodes ASCII chars a-z, useful for obfuscating
  # an email address from spiders and spammers
  def html_obfuscate(string)
    lower = ('a'..'z').to_a
    upper = ('A'..'Z').to_a
    string.split('').map { |char|  
      output = lower.index(char) + 97 if lower.include?(char)
      output = upper.index(char) + 65 if upper.include?(char)
      output ? "&amp;##{output};" : char
    }.join
  end
    
  # Takes in an email address and (optionally) anchor text,
  # its purpose is to obfuscate email addresses so spiders and
  # spammers can't harvest them.
  def js_antispam_email_link(email, linktext=email)
    user, domain = email.split('@')
    user   = html_obfuscate(user)
    domain = html_obfuscate(domain)
    # if linktext wasn't specified, throw encoded email address builder into js document.write statement
    linktext = "'+'#{user}'+'@'+'#{domain}'+'" if linktext == email 
    rot13_encoded_email = rot13(email) # obfuscate email address as rot13
    out =  "<noscript>#{linktext}<br/><small>#{user}(at)#{domain}</small></noscript>\n" # js disabled browsers see this
    out += "<script language='javascript'>\n"
    out += "  <!--\n"
    out += "    string = '#{rot13_encoded_email}'.replace(/[a-zA-Z]/g, function(c){ return String.fromCharCode((c <= 'Z' ? 90 : 122) >= (c = c.charCodeAt(0) + 13) ? c : c - 26);});\n"
    out += "    document.write('<a href='+'ma'+'il'+'to:'+ string +'>#{linktext}</a>'); \n"
    out += "  //-->\n"
    out += "</script>\n"
    return out
  end  
end
