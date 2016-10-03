class Moth < Sinatra::Application
  get "/" do
    haml :index, locals: {applications: Application.all}
  end
end
