# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  require 'feed_tools'
  helper :all # include all helpers, all the time+
  helper_method :fix_host

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '0a7293f44a137980504fa780e609276b'
  
  
  def fix_host(content, link)
    host = URI.parse(link).host
      if host != "feeds.feedburner.com"
        content.gsub!("src=\"/", "src=\"http://"+host+"/")
      end
    return content
   end
   
end
