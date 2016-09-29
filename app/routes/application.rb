class Moth < Sinatra::Application
  get "/applications" do
    haml :list, locals: { list: Application.all }
  end

  post "/application" do
    application = Application.new(name: params[:name], user: current_user)
    haml :list, locals: { list: application }
  end
end
