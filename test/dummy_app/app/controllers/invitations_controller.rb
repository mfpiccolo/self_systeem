class InvitationsController < ApplicationController

  def edit
    set_user
  end

  def update
    set_user

    if @user.update_attributes(user_params)
      @user.clear_invitation_token!
      sign_in(:user, @user)
      redirect_to after_sign_in_path_for(@user), notice: "Welcome to Finishes!"
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def set_user
    @user = User.find_by_invitation_token(params[:token])
  end

end
