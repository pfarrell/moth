require 'spec_helper'

describe User do
  context '#set_password' do
    let(:user) { User.new }
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
