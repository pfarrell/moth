require 'spec_helper'

describe 'App' do
  it "should allow access to the home page" do
    get "/"
    expect(last_response).to be_ok
  end

end
