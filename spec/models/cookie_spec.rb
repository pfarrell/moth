require 'spec_helper'

describe Cookie do
  let(:token) { Token.new(user: user) }
  let(:user) { User.new.save }

  context ("#intialize") do
    it "must be intialized with a Token" do
      expect(Cookie.new(token)).to be_a Cookie
    end
  end
end
