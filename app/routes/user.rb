class Moth < Sinatra::Application

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

  get "/user/password_reset" do
    haml :password_reset
  end

  get "/user/:id" do
    protected
    user = User[params[:id].to_i]
    haml :entity, locals: { entity: user }
  end
end
