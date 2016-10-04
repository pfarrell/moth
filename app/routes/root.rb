class Moth < Sinatra::Application
  get "/" do
    haml :index, locals: {applications: Application.all, current_user: current_user }
  end
end
