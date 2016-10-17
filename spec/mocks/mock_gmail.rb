class MockGmail
  def self.send_login(email, token, &block)
    yield
  end

  def self.connect(user, pass)
    yield MockConnection.new
  end

end

class MockConnection
  def deliver(&block)
    if block_given?
      Mail.new(&block)
    end
    true
  end
end

