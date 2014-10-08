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
		@user.update_attribute(:name, sign_up_params[:name])
    @user.update_attribute(:surname, sign_up_params[:surname])
		@user.save
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :surname, :email, :password, :password_confirmation)
  end

  def after_update_path_for(resourse)
	  persons_profile_path
  end
end
