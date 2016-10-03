class Moth < Sinatra::Application
  get "/user/:id" do
    protected
    user = User.find(email: params[:email])
    haml :entity, locals: { entity: user }
  end

  post "/user" do
    user = User.new(email: params[:email], name: params[:name])
    user.set_password(params[:password])
    user.save
    haml :entity, locals: { entity: user }
  end

  get "/users" do
    protected
    haml :list, locals: {list: User.all, headers: User.columns, title: "User"}
  end
end
