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

post "/admin/page/new" do
  save_by_params(params)
  redirect to "/admin/config"
end

get "/admin/page/:id/new" do
  @page = Page.new
  @page.root = false
  @page.page_id = params[:id]
  erb :new_page, :layout => :admin_layout
end

post "/admin/page/:id/new" do
  save_by_params(params)
  redirect to "/admin/config"
end

get "/admin/page/:id/edit" do
  @page = Page.get(params[:id])
  erb :new_page, :layout => :admin_layout
end

post "/admin/page/:id/edit" do
  save_by_params(params,page)
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
