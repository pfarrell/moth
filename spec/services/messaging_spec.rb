require 'spec_helper'

describe 'Messaging' do
  let(:app_name) { "dragons" }
  let(:application) { Application.find_or_create(name: app_name) }
  let(:subject) { Messaging.new(MockGmail) }

  context '.send_password_reset' do
    it 'sends password reset' do
      subject.send_password_reset(application, 'test@example.com', '12345')
    end
  end

  context 'connect' do
    it 'connects to argued service type: MockGmail' do
      subject.connect do |connection|
        expect(connection).to be_a MockConnection
      end
    end
  end
end
