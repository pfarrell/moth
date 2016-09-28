require 'spec_helper'

describe Token do
  context '#initialize' do
    let(:token) { Token.new }

    it 'generates a token' do
      expect(token.token).to be_a String
    end

    it 'generates an expiration' do
      expect(token.expires).to be_a Time
    end
  end

  context '.valid?' do
    let(:token) { Token.new }

    it 'checks token validity based on time' do
      expect(token.valid?).to be true
    end
  end
end
