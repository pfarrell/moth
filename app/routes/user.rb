class Moth < Sinatra::Application
  get "/user/:id" do
    user = User.find(email: params[:email])
    User.login(params[:email], params[:password]) ? "success" : "fail"
  end

  post "/user" do
    user = User.new(email: params[:email], name: params[:name])
    redirect(url_for("/"))
  end
end
