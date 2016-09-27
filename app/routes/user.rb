class Moth < Sinatra::Application
  get "/user/:id" do
    user = User.find(email: params[:email])
    User.login(params[:email], params[:password]) ? "success" : "fail"
  end

  post "/user" do
    user = User.new(email: params[:email], name: params[:name])
    user.set_password(params[:password])
    user.save
    redirect(url_for("/"))
  end

  get "/users" do
    haml :list, locals: {list: User.all}
  end
end
