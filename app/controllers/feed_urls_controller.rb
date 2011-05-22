class FeedUrlsController < ApplicationController
  before_filter :authenticate
  
  # GET /feed_urls
  # GET /feed_urls.json
  def index
    @feed_urls = FeedUrl.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @feed_urls }
    end
  end

  # GET /feed_urls/1
  # GET /feed_urls/1.json
  def show
    @feed_url = FeedUrl.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @feed_url }
    end
  end

  # GET /feed_urls/new
  # GET /feed_urls/new.json
  def new
    @feed_url = FeedUrl.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @feed_url }
    end
  end

  # GET /feed_urls/1/edit
  def edit
    @feed_url = FeedUrl.find(params[:id])
  end

  # POST /feed_urls
  # POST /feed_urls.json
  def create
    @feed_url = FeedUrl.new(params[:feed_url])

    respond_to do |format|
      if @feed_url.save
        format.html { redirect_to @feed_url, notice: 'Feed url was successfully created.' }
        format.json { render json: @feed_url, status: :created, location: @feed_url }
      else
        format.html { render action: "new" }
        format.json { render json: @feed_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /feed_urls/1
  # PUT /feed_urls/1.json
  def update
    @feed_url = FeedUrl.find(params[:id])

    respond_to do |format|
      if @feed_url.update_attributes(params[:feed_url])
        format.html { redirect_to @feed_url, notice: 'Feed url was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @feed_url.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feed_urls/1
  # DELETE /feed_urls/1.json
  def destroy
    @feed_url = FeedUrl.find(params[:id])
    @feed_url.destroy

    respond_to do |format|
      format.html { redirect_to feed_urls_url }
      format.json { head :ok }
    end
  end
  
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
