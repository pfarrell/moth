require 'spec_helper'
require 'byebug'

describe 'Moth' do

    let(:email) { "test@example.com" }
    let(:app_name) { "dragons" }
    let(:password) { "password" }
    let(:name) { "test namee" }
    let(:user) {
      user = User.find_or_create(email: email)
      user.set_password password
      user.save
      user
    }

    let(:token) {
      t=Token.new(
        user: user,
        type: "auth"
      ).save
      t
    }

    let(:cookie) {
      Cookie.new(
        token,
        profile_url: "test",
        logout_url: "test",
      )
    }

    let(:application) {
      app = Application.find_or_create(name: app_name, redirect: 'http://example.com', homepage: 'http://example.net')
      app.add_user user
      app
    }

  def authenticate
    set_cookie "auth=#{Base64.strict_encode64(cookie.to_json())}"
  end

  context "get url paths" do

    before do
      user
      application
    end

    ["/", "/users", "/applications", "/applications"].each do |path|
      it "should allow access to the #{path} page" do
        authenticate
        get "#{path}"
        expect(last_response).to be_ok
      end
    end

    ["/users", "/application", "/applications"].each do |path|
      it "should deny unauthenticated access to the #{path} page" do
        get "#{path}"
        expect(last_response).to_not be_ok
      end
    end

    it "should allow access to the /user/:id page" do
      authenticate
      get "/user/#{user.id}"
      expect(last_response).to be_ok
    end

    it "should authenticate access to the /user/:id page" do
      get "/user/#{user.id}"
      expect(last_response).to_not be_ok
    end

    it "should allow access to the /application/:id page" do
      authenticate
      get "/application/#{application.id}"
      expect(last_response).to be_ok
    end

    it "loads application login pages" do
      get "/application/#{application.id}/login"
      expect(last_response).to be_ok
    end

    it "redirects to applications pages" do
      post "/application/#{application.id}/login", {email: email, password: password}
      expect(last_response).to be_redirect
    end

    it "denies unauthenticated application logins" do
      post "/application/#{application.id}/login"
      expect(last_response).to_not be_ok
    end

    it "should allow logins" do
      post "/login", {email: email, password: password}
      expect(last_response).to be_ok
    end

    it "should allow logins" do
      post "/login.json", {email: email, password: password}, {'HTTP_AUTH_TOKEN' => token.token}
      expect(JSON.parse(last_response.body)).to be_a Hash
    end

    it "should allow users to be created" do
      post "/user", {name: name, email: "#{email}_test", password: password}
      expect(last_response).to be_ok
    end

    it "should allow applications to be created" do
      authenticate
      post "/application", { name: name }
      expect(last_response).to be_redirect
    end

    it "should not allow invalid logins" do
      post "/login", {email: email, password: "garbage"}
      expect(last_response.status).to eq(401)
    end

    it "adds users to applications" do
      authenticate
      post "/application/#{application.id}/users"
      expect(last_response).to be_ok
    end

    it "logs out users" do
      authenticate
      get "/application/#{application.id}/logout"
      expect(rack_mock_session.cookie_jar["auth"]).to be_empty
      expect(last_response).to be_redirect
    end

    it "adds users to applications" do
      app2 = Application.find_or_create(name: "new app", redirect: 'http://example.com', homepage: 'http://example.net')
      authenticate
      post "/application/#{app2.id}/user/#{user.id}"
      expect(last_response).to be_redirect
    end

    it "allows calls to add users to applications they already belong to" do
      authenticate
      post "/application/#{application.id}/user/#{user.id}"
      expect(last_response).to be_redirect
    end

    it "updates application names" do
      authenticate
      post "/application/#{application.id}", {name: "new name"}
      expect(Application[application.id].name).to eq("new name")
    end

    it "updates application redirects" do
      authenticate
      post "/application/#{application.id}", {redirect: "new redirect"}
      expect(Application[application.id].redirect).to eq("new redirect")
    end

    it "updates application homepages" do
      authenticate
      post "/application/#{application.id}", {homepage: "new homepage"}
      expect(Application[application.id].homepage).to eq("new homepage")
    end
  end

  context "/user" do
    it "creates users" do
      #authenticate
      post "/user", {email: "#{email}new", password: password, name: name}
      expect(last_response).to be_ok
      expect(User.find(email: "#{email}new", name: name)).to_not be_nil
    end

  end
end
