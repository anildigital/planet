class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :fix_host


  def fix_host(content, link)
    host = URI.parse(link).host
      if host != "feeds.feedburner.com"
        content.gsub!("src=\"/", "src=\"http://"+host+"/")
      end
    return content
   end
   
end
