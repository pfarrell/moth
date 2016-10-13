class Moth < Sinatra::Application
  get "/user/:id" do
    protected
    user = User[params[:id].to_i]
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

  get "/user/:id/logout" do
    protected
    auth_token = cookies.delete("auth")
    Token.find(token: auth_token)&.expire if auth_token
    redirect url_for('/')
  end

  get "/user/password_reset" do
    haml :password_reset
  end

  post "/user/password_reset" do
    user = User.find(email: params[:email])
    if user
      token = Token.new(user: user, type: "pwreset")
      send_reset_email(user)
    else
      sleep(rand)
    end
    haml :password_reset, flash: "If this email was registered, a reset token has been sent to the registered email"
  end
end
