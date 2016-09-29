require 'spec_helper'

describe 'Moth' do
  context "get url paths" do
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
    let(:token) { Token.new(user: user).save }
    let(:application) { Application.find_or_create(name: app_name) }

    before do
      user
      application
      token
    end

    ["/", "/users", "/applications"].each do |path|
      it "should allow access to the #{path} page" do
        get "#{path }"
        expect(last_response).to be_ok
      end
    end

    it "should allow access to the /user/:id page" do
      get "/user/#{user.id}"
      expect(last_response).to be_ok
    end

    it "should allow access to the /application/:id page" do
      get "/application/#{application.id}"
      expect(last_response).to be_ok
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
      expect(last_response).to be_redirect
    end

    it "should allow applications to be created" do
      post "/application", { name: name }, {'HTTP_AUTH_TOKEN' => token.token}
      expect(last_response).to be_redirect
    end

    it "should not allow invalid logins" do
      post "/login", {email: email, password: "garbage"}
      expect(last_response.status).to eq(401)
    end

  end
end
