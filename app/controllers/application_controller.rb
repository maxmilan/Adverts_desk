class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do
    flash[:notice] = 'Access denied'
    redirect_to root_path
  end

  rescue_from ActiveRecord::RecordNotFound do
    flash[:notice] = 'Incorrect address'
    redirect_to root_path
  end

  protect_from_forgery with: :exception
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def ensure_signup_complete
    return if action_name == 'finish_signup'
    if current_user && !current_user.email_verified?
      redirect_to finish_signup_path(current_user)
    end
  end

protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name << :surname
  end
end
