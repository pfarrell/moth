require 'spec_helper'

describe User do
  let(:email) { "test@example.com" }
  let(:password) { "password" }
  let(:user) { 
    user = User.find_or_create(email: "test@example.com")
    user.set_password password
    user.save
    user
  }

  context '.login' do
    before do
      user
    end

    it "logs in users" do
      expect(User.login(email, password)).to_not be_nil
    end

  end

  context '#set_password' do
    it 'generates a hashed password' do
      user.set_password('test')
      expect(user.password).to be_a String
    end

    it 'saves the salt' do
      user.set_password('test')
      expect(user.salt).to be_a String
    end
  end
end
