xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do

    xml.title "Planet Rails Feed"
    xml.description "Combines top rails blogs feeds into one."
    xml.link "http://feeds.feedburner.com/PlanetRails"

    for feed in @feeds
      xml.item do
        xml.title feed.title
        xml.description feed.content
        xml.pubDate feed.published.to_s(:rfc822)
        xml.link feed.link
        xml.guid feed.link
      end
    end
  end
end

