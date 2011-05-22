class PagesController < ApplicationController
  #
  # index
  #
  def index
    @feeds = Feed.order("updated_at DESC").page params[:page]
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
    @feeds = Feed.where(["content like ? or title like ?", "%"+query+"%", "%"+query+"%"]).order("published DESC").page params[:page]
    render :action => "index"
  end
  
  #
  # channels
  #
  def channels
    @feed_urls = FeedUrl.order(:title)
    render :layout => false
  end
end
