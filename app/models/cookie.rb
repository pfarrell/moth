class Cookie
  attr_accessor :token, :profile_url, :logout_url

  def initialize(token, opts={})
    @token = token.token
    @profile_url = opts[:profile_url]
    @logout_url = opts[:logout_url]
  end

  def to_json(opts={})
    {
      token: @token,
      profile_url: @profile_url,
      logout_url: @logout_url,
    }.to_json(opts)
  end

end
