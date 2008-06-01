namespace :utils do
  
  task(:populate_feeds => :environment) do
    feed_urls = FeedUrl.find(:all)

    feed_urls.each do |feed_url|
      begin
        xml = feed_url.fetch_feed
        feed_url.process_feed(xml)
      rescue Exception => e
        puts e.message
      end
    end
    
  end
end
