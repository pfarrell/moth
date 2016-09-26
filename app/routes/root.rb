class Moth < Sinatra::Application
  get "/" do
    haml :index
  end
end
