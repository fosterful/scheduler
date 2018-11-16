class RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  before_action :authorize_role, only: :new

  private

  def after_inactive_sign_up_path_for(_resource)
    new_user_session_path
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
  end

  def authorize_role
    return if params.dig(:user, :role).in? User::REGISTERABLE_ROLES
    redirect_to new_user_session_path, flash: { error: 'User role is required for registration' }
  end
end
