require 'spec_helper'

describe Cookie do
  let(:token) { Token.new }

  context ("#intialize") do
    it "can be initialized with nothing" do
      expect(Cookie.new).to be_a Cookie
    end

    it "can be intialized with a Token" do
      expect(Cookie.new(token)).to be_a Cookie
    end
  end
end
