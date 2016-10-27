class Moth < Sinatra::Application
  include ModelHelpers

  def merge(hsh)
    {headers: Application.columns, title: "Applications"}.merge hsh
  end

  get "/applications" do
    protected
    haml :list, locals: merge({ list: current_user.applications })
  end

  get "/application/:id" do
    protected
    haml :application, locals: { application: application_from_params }
  end

  get "/application/:id/login" do
    haml :login, locals: {application: application_from_params, current_user: current_user, return_to: params[:return_to]}
  end

  get '/application/:id/logout' do
    protected
    puts "cookies: #{cookies.keys}"
    auth_token = cookies.delete("auth")
    puts "del cks: #{cookies.keys}"
    Token.find(token: auth_token, type: "auth")&.expire if auth_token
    puts "application.homepage: #{application_from_params.homepage}"
    puts "cookies: #{cookies.keys}"
    redirect application_from_params.homepage
  end

  post "/application/:app_id/user/:user_id" do
    user = User[params[:user_id].to_i]
    application = Application[params[:app_id].to_i]
    unless user.applications.include? application
      user.add_application application
      user.save
    end
    redirect application.redirect
  end

  post "/application/:id/login" do
    user = User.find(email: params[:email])
    if user && User.login(params[:email], params[:password])
      token = Token.where(user: user, type: "auth").all.select{|x| x.expires > Time.now.utc}.first
      token = Token.new(user: user, type: "auth").save unless token
      respond_to do |wants|
        wants.json { token.to_json }
        wants.html {
          cookie = Cookie.new(token, name: user.name, profile_url: full_path(url_for("/user/#{user.id}")), logout_url: full_path(url_for("/application/#{application_from_params.id}/logout")))
          response.set_cookie(:auth, value: Base64.strict_encode64(cookie.to_json), path: "/", expires: token.expires)
          redirect (params[:return_to] || application_from_params.redirect)
        }
      end
    else
      status 401
      respond_to do |wants|
        wants.html { haml :login, locals: { application: application_from_params, error_message: "Login or password incorrect", return_to: params[:return_to]}}
        wants.json { halt 401, "Login failure" }
      end
    end
  end

  get "/application" do
    haml :application, locals: { application: nil }
  end

  post "/application" do
    protected
    application = Application.find_or_create(name: params[:name], redirect: params[:redirect], homepage: params[:homepage])
    application.add_user current_user
    application.save
    redirect url_for("/application/#{application.id}")
  end

  post "/application/:id" do
    protected
    application = application_from_params
    application.name = params[:name]
    application.redirect = params[:redirect]
    application.homepage = params[:homepage]
    application.save
    haml :application, locals: { application: application }
  end

  post "/application/:id/users" do
    user = user_from_params.save
    application = application_from_params
    ret = application.save
    application.add_user user
    respond_to do |wants|
      wants.html { haml :entity, locals: { entity: user } }
      wants.json { ret.to_json }
    end
  end

  post "/application/:id/password_reset" do
    user = User.find(email: params[:email])
    if user
      token = Token.new(user: user, type: "pwreset")
      settings.email.send_password_reset(application_from_params, current_user.email, token)
    else
      sleep(rand)
    end
    haml :password_reset, flash: "If this email was registered, a reset token has been sent to the registered email"
  end

end
