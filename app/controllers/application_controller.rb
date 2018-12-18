class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def configure_permitted_parameters
    policy = Pundit.policy(current_user || User.new, User)
    devise_parameter_sanitizer.permit(:invite, keys: policy.permitted_attributes_for_create)
    devise_parameter_sanitizer.permit(:accept_invitation, keys: policy.permitted_attributes)
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end
end
