class Cookie
  attr_accessor :token, :profile_url, :logout_url, :name

  def initialize(token, opts={})
    @token = token.token
    @profile_url = opts[:profile_url]
    @logout_url = opts[:logout_url]
    @name= opts[:name]
  end

  def to_json(opts={})
    {
      token: @token,
      profile_url: @profile_url,
      logout_url: @logout_url,
      name: @name,
    }.to_json(opts)
  end

end
