class RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
    @user = User.create sign_up_params
  end

  def update
    super
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :surname, :email, :password, :password_confirmation)
  end
end