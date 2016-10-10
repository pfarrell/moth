$: << File.expand_path('../app', __FILE__)

require 'sinatra'
require 'sinatra/url_for'
require 'sinatra/respond_to'
require 'sinatra/cookies'
require 'securerandom'
require 'haml'

class Moth < Sinatra::Application
  helpers Sinatra::UrlForHelper
  helpers Sinatra::Cookies
  register Sinatra::RespondTo

  enable :sessions
  set :session_secret, ENV["APP_SESSION_SECRET"] || "youshouldreallychangethis"
  set :views, Proc.new { File.join(root, "app/views") }

  helpers do
    def current_user
      cookie_token = request.env["HTTP_AUTH_TOKEN"] || request.cookies["auth"]
      Token.find(token: decode_token(cookie_token)[:token])&.user
    end

    def protected
      redirect(url_for("/?return=#{request.path}")) unless current_user
    end

    def decode_token(token)
      return {} if token.nil?
      JSON.parse(Base64.decode64(token), symbolize_names: true)
    end

    def full_path(url)
      "#{request.scheme}://#{request.host_with_port}#{url}"
    end
  end

  before do
    response.set_cookie(:appc, value: SecureRandom.uuid, expires: Time.now + 3600 * 24 * 365 * 10) if request.cookies["bmc"].nil?
  end
end

require 'models'
require 'routes'
