enable :sessions

def save_by_params(params, page = nil)

  params.delete("id")
  params.delete("page_id") if params["page_id"].empty?

  params["root"] = params[:root] == "true"
  params["footer"] = !!params["footer"]
  params["title"] = params["title"].downcase
 
  if page 
    page.update(params)
  else
    Page.create(params)
  end
end

before do
  redirect to "/admin/config" unless Page.first || request.path_info["admin"] 
end

require "./admin_routes.rb"

get "/" do
  redirect to "/#{Page.first(:language => language).title}"
end

get "/language" do
  session["language"] = params[:language]
  redirect back
end

get "/:url" do

  page = Page.first(:title => params[:url], :language => language)
  redirect to "/" unless page
  if page.plugin then
    @body = PLUGINS[page.plugin.to_i].to_html(page.plugin_params) 
    @title = page.localized_title
  else
    @body = Maruku.new(page.body).to_html
    @title = page.localized_title
  end
  erb :template

end

