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
  @body = Page.first(:language => language).body
  @title = Page.first(:language => language).localized_title
  erb :template
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

