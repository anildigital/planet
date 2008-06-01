require 'hpricot'
require 'open-uri'

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
      raise RunTimeError, 'Unknown feed type only RSS and Atom can be read'
    end
  end

  def process_rss(rss)
    puts "processing rss"
    time_offset = 1
    (rss/:channel/:item).each do |item|
      link = (item/:link).inner_html

      if ! (Feed.find_by_link(link))
        rss_feed = Feed.new
        rss_feed.feed_url = self
        rss_feed.title = (item/:title).inner_html
        rss_feed.link = link
        rss_feed.author = (item/:author).inner_html
        rss_feed.content = (item/:description).inner_html
        rss_feed.published = (item/:pubDate).inner_html

        if ! rss_feed.published
          rss_feed.published = Time.now - time_offset.hours
          time_offset += 1
        end
        rss_feed.title = htmlize(rss_feed.title)
        rss_feed.content = htmlize(rss_feed.content)    
        rss_feed.save!
      end
    end
  end

  def process_atom(atom)
    puts "processing atom"
    time_offset = 1
    (atom/:entry).each do |item|
      link = (item/:link).attr('href')
      if !(Feed.find_by_link(link))
        atom_feed = Feed.new
        atom_feed.feed_url = self
        atom_feed.title = (item/:title).inner_html
        atom_feed.link = link
        atom_feed.author = (item/:author/:name).inner_html
        atom_feed.content = (item/:content).inner_html
        atom_feed.published = (item/:published).inner_html

        if ! atom_feed.content
          atom_feed.content =  (item/:summary).inner_html
        end

        if ! atom_feed.published
          atom_feed.published =  Time.now - time_offset.hours 
          time_offset += 1
        end
        atom_feed.title = htmlize(atom_feed.title)
        atom_feed.content = htmlize(atom_feed.content)
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

  def htmlize(string)
    string.gsub!('&lt;', '<')
    string.gsub!('&gt;', '>')
    string.gsub!('&amp;', '&')
    string.gsub!('&#39;', "'")
    string.gsub!('&quot;', '"')
    string
  end

end
