class Cookie
  attr_accessor :user_id, :token, :profile_url, :logout_url, :name

  def initialize(token, opts={})
    @user_id = token.user.userid
    @token = token.token
    @profile_url = opts[:profile_url]
    @logout_url = opts[:logout_url]
    @name= opts[:name]
  end

  def to_json(opts={})
    {
      user_id: @user_id,
      token: @token,
      profile_url: @profile_url,
      logout_url: @logout_url,
      name: @name,
    }.to_json(opts)
  end

end
