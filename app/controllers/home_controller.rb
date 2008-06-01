class HomeController < ApplicationController
  def index
    @feeds = Feed.paginate(:all, :per_page => 5, :page => params[:page], :order => "published DESC")
  end
end
