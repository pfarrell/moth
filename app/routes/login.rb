class Moth < Sinatra::Application
  post "/login" do
    user = User.find(email: params[:email])
    if user && User.login(params[:email], params[:password])
      token = Token.where(user: user, type: "auth").all.select{|x| x.expires > Time.now.utc}.first
      token = Token.find_or_create(user: user, type: "auth") unless token
      respond_to do |wants|
        wants.json { token.to_json }
        wants.html {
          response.set_cookie(:auth, value: token.token, path: "/", expires: token.expires)
        }
      end
    else
      halt 401, "Not authorized\n"
    end
  end
end
