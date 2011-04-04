
helpers do

  def languages
    Page.all.map(&:language).uniq
  end

  def language
    session["language"] || "de"
  end

  def listify(pages, ulclass="")
    ret = "<ul class='#{ulclass}'>"
    ret += pages.sort_by(&:position).map do |page|
      "<li><a href='#{url("/" + page.title)}'>#{page.localized_title}</a>#{unless page.pages.empty? then listify page.pages end}<li>"
    end.join("")
    ret += "</ul>"
    ret
  end

  def nav_bar
    listify Page.all(:language => language, :root => true, :footer => false), "sf-menu"
  end

  def footer
    Page.all(:language => language, :footer => true).map do |page|
      "<a href='#{url("/" + page.title)}'>#{page.localized_title}</a>"
    end.join(" | ")
  end
end
