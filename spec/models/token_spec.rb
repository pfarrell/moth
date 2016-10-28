require 'spec_helper'

describe Token do
  let(:token) { Token.new }

  context '#initialize' do
    it 'generates a token' do
      expect(token.token).to be_a String
    end

    it 'generates an expiration' do
      expect(token.expires).to be_a Time
    end
  end

  context '.valid?' do
    it 'checks token validity based on time' do
      expect(token.valid?).to be true
    end
  end

  context '.expire' do
    it "expires tokens" do
      expect(token.expire.deleted_at).to_not be_nil
    end
  end
end
