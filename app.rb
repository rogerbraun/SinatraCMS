enable :sessions

helpers do

  def languages
    Page.all.map(&:language).uniq
  end

  def language
    session["language"] || "de"
  end

  def listify(pages)
    ret = "<ul>"
    ret += pages.sort_by(&:position).map do |page|
      "<li><a href='#{url("/" + page.title)}'>#{page.localized_title}</a>#{unless page.pages.empty? then listify page.pages end}<li>"
    end.join("")
    ret += "</ul>"
    ret
  end

  def nav_bar
    ret = "<ul class='sf-menu'>"
    ret += Page.all(:language => language, :root => true, :footer => false).sort_by(&:position).map do |page|
      "<li><a href='#{url("/" + page.title)}'>#{page.localized_title}</a>#{
        unless page.pages.empty?
          listify(page.pages)
        end}</li>"
      end.join("")

    ret += "</ul>"
    ret
  end

  def footer
    Page.all(:language => language, :footer => true).map do |page|
      "<a href='#{url("/" + page.title)}'>#{page.localized_title}</a>"
    end.join(" | ")
  end
end

before do
  redirect to "/admin/config" unless Page.first || request.path_info["admin"] 
end

get "/" do
  @body = Page.first(:language => language).body
  @title = Page.first(:language => language).localized_title
  erb :template
end

get "/admin/config" do
  @pages = Page.all(:footer => false).sort_by(&:position)
  @foot_pages = Page.all(:footer => true).sort_by(&:position)
  erb :config, :layout => :admin_layout
end

get "/admin/page/new" do
  @page = Page.new
  @page.root = true
  erb :new_page, :layout => :admin_layout
end

get "/admin/page/:id/new" do
  @page = Page.new
  @page.root = false
  @page.page_id = params[:id]
  erb :new_page, :layout => :admin_layout
end

get "/admin/page/:id/edit" do
  @page = Page.get(params[:id])
  erb :new_page, :layout => :admin_layout
end

post "/admin/page/:id/edit" do
  @page = Page.get(params[:id])
  params.delete("id")
  params.delete("page_id") if params["page_id"].empty?

  params["root"] = params[:root] == "true"
  params["footer"] = !!params["footer"]
  
  puts params
  @page.update(params)
  
  redirect to "/admin/config"
end

post "/admin/page/new" do
  params.delete("page_id")
  params["root"] = params[:root] == "true"
  params["footer"] = !!params["footer"]
  params["title"] = params["title"].downcase
  puts params
  Page.create(params)
  redirect to "/admin/config"
end

post "/admin/page/:id/new" do
  params.delete("id")
  params["root"] = params[:root] == "true"
  params["footer"] = !!params["footer"]
  params["title"] = params["title"].downcase
  puts params
  Page.create(params)
  redirect to "/admin/config"
end

post "/admin/page/:id/move_up" do
  cur = Page.get(params[:id])
  unless cur.position == 0
    temp = Page.first(:position => cur.position - 1)
    temp.update(:position => cur.position)
    cur.update(:position => cur.position - 1)
  end
  redirect back
end

get "/language" do
  session["language"] = params[:language]
  redirect back
end

get "/:url" do

  page = Page.first(:title => params[:url], :language => language)
  redirect to "/" unless page
  @body = page.body
  @title = page.localized_title
  erb :template

end

