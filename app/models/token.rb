class Token < Sequel::Model
  many_to_one :app
  many_to_one :user

  def initialize(opts={})
    super(opts)
    token = SecureRandom.hex
    valid_until = (Time.now + 7 * 24 * 3600).utc
  end

  def valid?
    (Time.now + 7 * 24 * 3600).utc < self.valid_until
  end
end
