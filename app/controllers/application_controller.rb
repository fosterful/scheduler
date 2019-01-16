class ApplicationController < ActionController::Base
  include Pundit
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  # around_action :set_time_zone

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def configure_permitted_parameters
    policy = Pundit.policy(current_user || User.new, User)
    devise_parameter_sanitizer.permit(:invite, keys: policy.permitted_attributes_for_create)
    devise_parameter_sanitizer.permit(:accept_invitation, keys: policy.permitted_attributes)
  end

  def user_not_authorized
    respond_to do |format|
      format.html do
        flash[:alert] = 'You are not authorized to perform this action.'
        redirect_to(request.referrer || root_path)
      end
      format.json do
        render json: {}, status: :unauthorized
      end
    end
  end

  def set_time_zone
    Time.zone = current_user.time_zone
    yield
  ensure
    Time.zone = Scheduler::Application.config.time_zone
  end
end
