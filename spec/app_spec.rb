require 'spec_helper'

describe 'Moth' do
  context "get url paths" do
    let(:email) { "test@example.com" }
    let(:app_name) { "dragons" }
    let(:user) { User.find_or_create(email: email) }
    let(:application) { Application.find_or_create(name: app_name) }

    before do
      user
      application
    end

    ["/", "/users", "/applications"].each do |path|
      it "should allow access to the #{path} page" do
        get "#{path }"
        expect(last_response).to be_ok
      end
    end

    #it "should allow access to the /user/:id page" do
    #  get "/user/#{user.id}"
    #  expect(last_response).to be_ok
    #end

    #it "should allow access to the /app/:id page" do
    #  get "/user/#{app.id}"
    #  expect(last_response).to be_ok
    #end

  end
end
