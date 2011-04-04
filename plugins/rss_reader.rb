require "feedzirra"

class RSSReader
  attr_reader :name

  def initialize
    @name = "RSS Reader" 
    @description = "Renders an RSS-Feed"
  end

  def to_html(param)
    feed = Feedzirra::Feed.fetch_and_parse param
    puts feed
    out = feed.entries.map do |entry|
      "<h4>#{entry.published}</h4>
       <p>#{entry.content || entry.summary}</p>"
    end.join("")
    puts out
    out
  end

end
