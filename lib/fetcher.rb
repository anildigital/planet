class Fetcher
  # Fetches Cached feeds table
  def self.fetch
    feeds = FeedUrl.find(:all)
    feeds_array = feeds.collect{|i| i.feed_url}
    puts "building merged feed"
    rails_planet = FeedTools.build_merged_feed(feeds_array)
    return rails_planet
  end

  # Populates RSS feed table
  def self.populate
    feed_records = CachedFeed.find(:all)
    feeds = FeedUrl.find(:all)
    star_feeds = feeds.select{|i| i.star == "Y"}
    star_feed_urls = feeds.collect{|i| i.feed_url}
    for i in feed_records
      feedtools_object = FeedTools::Feed.new
      feedtools_object.feed_data = i.feed_data
      feedtools_object.href = i.href
      for i in feedtools_object.items
        feed = Feed.new
        feed.link = i.link
        feed.title = i.title
        feed.description = i.description
        feed.pubDate = i.published
        feed.site_url = i.base_uri
        feed.href = feedtools_object.href
        puts feed.site_url
        if star_feed_urls.include?(feedtools_object.href)
          feed.star = "Y"
        else
          feed.star = "N"
        end
        feed.copyright = i.copyright
        feed.license = i.license
        feed.feed_version = i.feed_version
        feed.tags = i.tags
        feed.updated = i.updated
          begin
            feed.save!
          rescue Exception => e
            if e.message == "Validation failed: Title has already been taken"
            # skip
            else
              raise $!
            end
          end
        end
      end
    end
end
