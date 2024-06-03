class AuthController < ApplicationController
  skip_before_action :authorized, only: :login
  # POST /auth/login
  def login
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    render json: { auth_token: auth_token }, status: :ok
  end

  private

  def auth_params
    params.require(:auth).permit(:email, :password)
  end
end
