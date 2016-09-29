class Moth < Sinatra::Application

  def merge(hsh)
    {headers: Application.columns, title: "Applications"}.merge hsh
  end

  get "/applications" do
    haml :list, locals: merge({ list: Application.all })
  end

  get "/application/:id" do
    haml :entity, locals: { entity: Application[params[:id].to_i]}
  end

  post "/application" do
    application = Application.new(name: params[:name], user: current_user)
    redirect url_for("/application/#{application.id}")
  end
end
