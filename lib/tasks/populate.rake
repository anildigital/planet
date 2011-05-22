namespace :utils do
  
  desc "Populates feeds table"
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
  
  # Removes duplicate feeds.
  task(:delete_duplicate_feeds => :environment) do
    FeedUrl.cleanup_feeds()
  end
  
end
