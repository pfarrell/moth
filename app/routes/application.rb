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
    haml :login, locals: {application: application_from_params}
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
        }
      end
    else
      halt 401, "Not authorized\n"
    end
    redirect application_from_params.redirect
  end

  get "/application" do
    protected
    haml :application
  end

  post "/application" do
    protected
    application = Application.find_or_create(name: params[:name])
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
