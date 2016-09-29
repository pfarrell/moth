class Token < Sequel::Model
  many_to_one :application
  many_to_one :user

  def initialize(opts={})
    super(opts)
    self.token = SecureRandom.hex
    self.expires = (Time.now + 7 * 24 * 3600).utc
  end

  def valid?
    self.expires < (Time.now + 7 * 24 * 3600).utc
  end
end
