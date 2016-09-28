class Moth < Sinatra::Application
  post "/login" do
    user = User.find(email: params[:email])
    if user && User.login(params[:email], params[:password])
      token = Token.where(user: user).all.select{|x| x.expires > Time.now.utc}.first
      respond_to do |wants|
        wants.json {}
        wants.html {
          response.set_cookie(:auth, value: token.token, path: "/", expires: token.expires)
        }
      end
    else
      halt 401, "Not authorized\n"
    end
  end

  get "/login/:token" do
  
  end
end
