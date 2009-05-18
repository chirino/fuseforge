# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  include TagsHelper

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
  
  def public_path(source)
    "#{ActionController::Base.relative_url_root}#{source}"
  end
  
end
