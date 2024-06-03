class AuthController < ApplicationController
  def register
    @users = User.new(user_params)
    if @users.save
      
end
