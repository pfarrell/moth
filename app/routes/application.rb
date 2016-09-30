class Moth < Sinatra::Application

  def merge(hsh)
    {headers: Application.columns, title: "Applications"}.merge hsh
  end

  get "/applications" do
    protected
    haml :list, locals: merge({ list: Application.where(user: current_user).all })
  end

  get "/application/:id" do
    protected
    haml :entity, locals: { entity: Application[params[:id].to_i]}
  end

  get "/application/:id/login" do
    haml :index, locals: { application: Application[params[:id].to_i]}
  end

  get "/application" do
    protected
    haml :application
  end

  post "/application" do
    protected
    application = Application.find_or_create(name: params[:name])
    application.add_user current_user
    application.save
    redirect url_for("/application/#{application.id}")
  end
end
