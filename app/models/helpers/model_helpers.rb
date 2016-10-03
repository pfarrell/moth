module ModelHelpers
  def application_from_params
    Application[params[:id].to_i]
  end

  def user_from_params
    user = User.new(email: params[:email], name: params[:name])
    user.set_password params[:password]
    user
  end
end
