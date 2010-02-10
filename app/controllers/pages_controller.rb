class PagesController < ApplicationController

  
  #
  # index
  #
  def index
    @feeds = Feed.paginate(:all, 
                           :per_page => 15, 
                           :page => params[:page], 
                           :order => "published DESC")
    
    expires_in 5.minutes, :private => false, :public => true
  end
  
  
  #
  # used to render rss.
  #
  def show
    index
  end
  
  #
  # search
  #
  def search
    query = params[:query]
    query = (query && query.strip) || ""
    @feeds = Feed.paginate(:all, 
                           :conditions => ["content like ? or title like ?", "%"+query+"%", "%"+query+"%"], 
                           :per_page => 15, 
                           :page => params[:page], 
                           :order => "published DESC")
    render :action => "index"
  end
end
