class Moth < Sinatra::Application
  get "/user/:id" do
    user = User.find(email: params[:email])
    haml :entity, locals: { entity: user }
  end

  post "/user" do
    user = User.new(email: params[:email], name: params[:name])
    user.set_password(params[:password])
    user.save
    redirect(url_for("/user/#{user.id}"))
  end

  get "/users" do
    haml :list, locals: {list: User.all, headers: User.columns, title: "User"}
  end
end
