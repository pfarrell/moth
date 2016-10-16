class Messaging
  attr_accessor :klass

  def initialize(klass)
    @klass = klass
  end

  def send_password_reset(application, email, token_link)
    require 'byebug'
    connect do |gmail|
      byebug
      gmail.deliver do
        to = email
        subject "#{application.name}:: Reset Your Password"
        text_part do
          body = "#{token_link}"
        end
        html_part do
          content_type 'text/html; charset=UTF-8'
          body %Q[<a href="#{token_link}">Reset your password?</a>?]
        end
      end
    end
  end

  def connect(&block)
    gmail_user = ENV["GMAIL_USER"]
    gmail_pass = ENV["GMAIL_PASS"]
    @klass.connect(gmail_user, gmail_pass) do |gmail|
      yield gmail
    end
  end
end
