class Moth < Sinatra::Application
  post "/login" do
    user = User.find(email: params[:email])
    (user && User.login(params[:email], params[:password])) ? "success" : "fail"
  end
end
