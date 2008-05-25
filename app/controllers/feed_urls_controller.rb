class FeedUrlsController < ApplicationController
  before_filter :authenticate
  
  # GET /feed_urls
  # GET /feed_urls.xml
  def index
    @feed_urls = FeedUrl.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @feed_urls }
    end
  end

  # GET /feed_urls/1
  # GET /feed_urls/1.xml
  def show
    @feed_url = FeedUrl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @feed_url }
    end
  end

  # GET /feed_urls/new
  # GET /feed_urls/new.xml
  def new
    @feed_url = FeedUrl.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @feed_url }
    end
  end

  # GET /feed_urls/1/edit
  def edit
    @feed_url = FeedUrl.find(params[:id])
  end

  # POST /feed_urls
  # POST /feed_urls.xml
  def create
    @feed_url = FeedUrl.new(params[:feed_url])

    respond_to do |format|
      if @feed_url.save
        flash[:notice] = 'FeedUrl was successfully created.'
        format.html { redirect_to(@feed_url) }
        format.xml  { render :xml => @feed_url, :status => :created, :location => @feed_url }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @feed_url.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /feed_urls/1
  # PUT /feed_urls/1.xml
  def update
    @feed_url = FeedUrl.find(params[:id])

    respond_to do |format|
      if @feed_url.update_attributes(params[:feed_url])
        flash[:notice] = 'FeedUrl was successfully updated.'
        format.html { redirect_to(@feed_url) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @feed_url.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_urls/1
  # DELETE /feed_urls/1.xml
  def destroy
    @feed_url = FeedUrl.find(params[:id])
    @feed_url.destroy

    respond_to do |format|
      format.html { redirect_to(feed_urls_url) }
      format.xml  { head :ok }
    end
  end
  
  # 
  def login
    session[:authenticated] = true
    render :text => "You have successfully logged in. <a href='/blog'>Back</a>"
  end
  
  # One way to logout from http authentication.
  # But it is specific to some browsers. So it won't work always.
  def logout
    render :text => "You logged out. <a href='/blog'>Back</a>", :status => 401
    session[:authenticated] = false
  end
  
  protected
  def authenticate
     authenticate_or_request_with_http_basic do | user_name, password|
      pwd = YAML::load_file("/etc/password.yml")["type"]["password"]
      user_name == "anil" && password == pwd
    end
  end
  
end
