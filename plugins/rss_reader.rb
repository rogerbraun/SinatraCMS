require "feedzirra"

class RSSReader
  attr_reader :name

  def initialize
    @name = "RSS Reader" 
    @description = "Renders an RSS-Feed"
  end

  def to_html(param)
    feed = Feedzirra::Feed.fetch_and_parse param
    out = feed.entries.map do |entry|
      "<h4>#{entry.title}</h4>
       <h5>#{entry.published}</h5>
       <p>#{entry.content || entry.summary}</p>"
    end.join("")
    out
  end

end
