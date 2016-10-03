class User < Sequel::Model
  include BCrypt
  one_to_many  :logs
  one_to_many  :tokens
  many_to_many :applications

  def set_password(str)
    password = Password.create(str)
    self.password = password.to_s
    self.salt = password.salt
  end

  def self.login(email, password)
    user = User.find(email: email)
    return Password.new(user.password).is_password?(password)
  end

end
