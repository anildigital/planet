require 'hpricot'
require 'open-uri'
require 'uri'

class FeedUrl < ActiveRecord::Base
  
  has_many :feeds, :dependent => :delete_all
  validates_presence_of :feed_url
  validates_presence_of :title

  def process_feed(xml)
    doc = Hpricot.XML(xml)
    if doc.search(:rss).size > 0
      process_rss(doc)
      return 'rss'
    elsif doc.search(:feed).size > 0
      process_atom(doc)
      return 'atom'
    else
      raise RuntimeError, 'Unknown feed type only RSS and Atom can be read'
    end
  end

   # Process rss feed and saves it into db
  def process_rss(rss)
    puts "processing rss"
    time_offset = 1
    
    # taking out site/blog link and title.
    site_link = (rss/:channel/:link).first.inner_html
    site_title = (rss/:channel/:title).first.inner_html

    (rss/:channel/:item).each do |item|
      link = (item/:link).inner_html

      if ! (Feed.find_by_link(link))
        rss_feed = Feed.new
        rss_feed.feed_url = self
        rss_feed.site_link = site_link
        rss_feed.site_title = site_title
        rss_feed.title = (item/:title).inner_html
        rss_feed.link = link
        rss_feed.author = (item/:author).inner_html
        rss_feed.content = (item/:description).inner_html
        rss_feed.published = (item/:pubDate).inner_html

        if rss_feed.published.blank?
          puts "rss feed published time blank. calculating system one."
          rss_feed.published = (Time.now - time_offset.hours).to_s(:db)
          puts rss_feed.published
          time_offset += 1
        end
        
        rss_feed.title = htmlize(rss_feed.title)
        rss_feed.content = htmlize(rss_feed.content, link)    
        rss_feed.save!
      end
    end
  end
  
  # Process atom feed and saves it into db
  def process_atom(atom)
    puts "processing atom"
    time_offset = 1
    
    # taking out site/blog link and title.
    site_link =  (atom/:feed).search(:link).select{ |i| i['type'] == "text/html"}.first['href']
    site_title = (atom/:feed/:title).first.inner_html
    
    (atom/:entry).each do |item|
      link = (item/:link).attr('href')
      if !(Feed.find_by_link(link))
        atom_feed = Feed.new
        atom_feed.feed_url = self
        atom_feed.site_link = site_link
        atom_feed.site_title = site_title
        atom_feed.title = (item/:title).inner_html
        atom_feed.link = link
        atom_feed.author = (item/:author/:name).inner_html
        atom_feed.content = (item/:content).inner_html
        atom_feed.published = (item/:published).inner_html

        if atom_feed.content.blank?
          atom_feed.content =  (item/:summary).inner_html
        end

        if atom_feed.published.blank?
          atom_feed.published =  (Time.now - time_offset.hours).to_s(:db)
          time_offset += 1
        end
        
        atom_feed.title = htmlize(atom_feed.title)
        atom_feed.content = htmlize(atom_feed.content, link)
        atom_feed.save!
      end
    end
  end

  # Fetches RSS feed and returns back xml
  def fetch_feed
    rss = ""
    begin
      f = open(self.feed_url, 'r')
      rss = f.read()  
      f.close
    rescue Exception => e
      puts e.message
      puts "FeedUrl::fetch_feed :: Error in opening feed"
    end
    return rss
  end

  def htmlize(string, link=nil)
    string.gsub!('&lt;', '<')
    string.gsub!('&gt;', '>')
    string.gsub!('&amp;', '&')
    string.gsub!('&#39;', "'")
    string.gsub!('&quot;', '"')
    string.gsub!('<![CDATA[', '')
    string.gsub!(']]>', '')
    
    # for image srcs like <img src="/assets/2008/4/23/rails3.jpg_1208810865" />"
    # adding host so that they become valid
    # "<img src="http://www.google.com/assets/2008/4/23/rails3.jpg_1208810865" />"
    if link
    host = URI.parse(link).host
      if host != "feeds.feedburner.com"
        string.gsub!("src=\"/", "src=\"http://"+host+"/")
      end
    end
    return string
  end

end