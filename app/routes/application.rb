class Moth < Sinatra::Application
  get "/apps" do
    haml :list, locals: { list: App.all }
  end

  post "/app" do
    app = App.new(name: params[:name], user: current_user)
    haml :list, locals: { list: app }
  end
end
