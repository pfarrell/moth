class Moth < Sinatra::Application
  get "/user/:id" do
    user = User.find(email: params[:email])&.first
    password = Password.new("#{user.salt}-#{params[:password]}")
    if(user && user.password == password)
    end
  end

  post "/user" do
    user = User.new(email: params[:email], name: params[:name])
  end
end
