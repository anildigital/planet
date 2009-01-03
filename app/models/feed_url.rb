# == Schema Information
# Schema version: 2
#
# Table name: feed_urls
#
#  id         :integer(11)     not null, primary key
#  feed_url   :string(255)
#  title      :string(255)
#  star       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

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
    time_offset = 1

    # taking out site/blog link and title.
    site_link = (rss/:channel/:link).first.inner_html
    site_title = (rss/:channel/:title).first.inner_html
    puts "processing rss for #{site_link}"

    (rss/:channel/:item).each do |item|
      link_raw = item.%('feedburner:origLink') || item.%('link') || (item/:link)
      link = link_raw.inner_html

      if (Feed.find_by_link(link)).blank?
        rss_feed = Feed.new
        rss_feed.feed_url = self
        rss_feed.site_link = site_link
        rss_feed.site_title = site_title
        rss_feed.title = (item/:title).inner_html
        rss_feed.link = link
        rss_feed.author = (item/:author).inner_html
        rss_feed.content = (item/:description).inner_html
        if !(item/"content:encoded").blank?
          rss_feed.content = (item/"content:encoded").inner_html
        else
          rss_feed.content = (item/:description).inner_html
        end

        rss_feed.published = (item/:pubDate).inner_html

        if rss_feed.published.blank?
          # if !(rss/:channel/:lastBuildDate).inner_html.blank?
          #            puts "rss feed published time blank. taking lastBuildDate one"
          #            puts (rss/:channel/:lastBuildDate).inner_html
          #            time = (rss/:channel/:lastBuildDate).inner_html
          #            rss_feed.published = Time.parse(time).to_s(:db)
          #          else
          puts "rss feed published time blank. calculating system one."
          # taking it 20 days back..
          rss_feed.published = (Time.now - (20*60*60*24) - time_offset.hours).to_s(:db)
          time_offset += 1
          # end
        end

        rss_feed.title = htmlize(rss_feed.title)
        rss_feed.content = htmlize(rss_feed.content, link)
        rss_feed.save!
      end
    end
  end

  # Process atom feed and saves it into db
  def process_atom(atom)
    time_offset = 1

    # taking out site/blog link and title.
    site_link =  (atom/:feed).search(:link)[1]['href']
    site_title = (atom/:feed/:title).first.inner_html

    puts "processing atom for #{site_link}"

    (atom/:entry).each do |item|
      link_raw = item.%('feedburner:origLink') || item.%('link')

      if !link_raw.blank?
        link = (link_raw).inner_html
      else
        link = (item/:link).attr('href')
      end

      if (Feed.find_by_link(link)).blank?
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
          atom_feed.published =  (item/:updated).inner_html
        end

        if atom_feed.published.blank?
          # taking it 20 days back..
          atom_feed.published =  (Time.now - (20*60*60*24) - time_offset.hours).to_s(:db)
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

  # htmlize the html codes back.
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

  ## Removed duplicate entries
  ## Currently based on feed title. #TODO make it more correct.
  def self.cleanup_feeds
    feed_records = FeedUrl.find_by_sql("select count(title) as qty, feeds.id as feed_id from feeds group by title having qty > 1;")
    feed_ids = (feed_records.collect{|i| i.feed_id})
    Feed.delete(feed_ids)
  end

end
