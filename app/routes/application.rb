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
    haml :entity, locals: { entity: application_from_params }
  end

  get "/application/:id/login" do
    haml :login, locals: {application: application_from_params, current_user: current_user}
  end

  post "/application/:app_id/user/:user_id" do
    user = User[params[:user_id].to_i]
    application = Application[params[:app_id].to_i]
    user.add_application application
    user.save
    redirect application.redirect
  end

  post "/application/:id/login" do
    user = User.find(email: params[:email])
    if user && User.login(params[:email], params[:password])
      token = Token.where(user: user).all.select{|x| x.expires > Time.now.utc}.first
      token = Token.find_or_create(user: user) unless token
      respond_to do |wants|
        wants.json { token.to_json }
        wants.html {
          response.set_cookie(:auth, value: token.token, path: "/", expires: token.expires)
          redirect application_from_params.redirect
        }
      end
    else
      respond_to do |wants|
        wants.html { haml :login, locals: { application: application_from_params, error_message: "Login or password incorrect"}}
        wants.json { halt 401, "Login failure" }
      end
    end
  end

  get "/application" do
    protected
    haml :application
  end

  post "/application" do
    protected
    application = Application.find_or_create(name: params[:name], redirect: params[:redirect], homepage: params[:homepage])
    application.add_user current_user
    application.save
    redirect url_for("/application/#{application.id}")
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
end
