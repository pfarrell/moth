class Moth < Sinatra::Application

  def merge(hsh)
    {headers: Application.columns, title: "Applications"}.merge hsh
  end

  get "/applications" do
    protected
    haml :list, locals: merge({ list: current_user.applications })
  end

  get "/application/:id" do
    protected
    haml :entity, locals: { entity: Application[params[:id].to_i]}
  end

  get "/application/:id/login" do
    protected
    application = Application[params[:id].to_i]
    redirect application.redirect
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

  post "/application/:id/users" do
    protected
    application = Application[params[:id].to_i]
    application.add_user current_user
    ret = application.save
    respond_to do |wants|
      wants.html { haml :entity, locals: { entity: current_user } }
      wants.json { ret.to_json }
    end
  end
end
