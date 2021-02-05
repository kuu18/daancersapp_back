class Api::V1::UsersController < ApplicationController

  # POST /api/v1/users
  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      payload = { message: '新規登録に成功しました。', user: @user }
    else
      payload = { errors: @user.errors, status: :unprocessable_entity }
    end
    render json: payload
  end

  private

    def user_params
      params.permit(:name, :email, :password,
                                  :password_confirmation)
    end
end