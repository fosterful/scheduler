# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  DEFAULT_ERROR = 'Whoops! Something went wrong.'

  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :enforce_verification, if: :user_signed_in?
  before_action :enforce_covid_19_vaccinated, if: :user_signed_in?
  around_action :set_time_zone, if: :user_signed_in?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def authenticate_admin
    return if current_user.admin?

    redirect_to root_path, flash: { error: 'Not authorized.' }
  end

  def redis
    @redis ||= begin
      redis_connection = Redis.new(url: Rails.application.credentials.redis_url || ENV['REDIS_URL'])
      Redis::Namespace.new(Rails.env, redis: redis_connection)
    end
  end
  helper_method :redis

  def need_creation_disabled?
    redis.get('need_creation_disabled').present?
  end
  helper_method :need_creation_disabled?

  private

  def configure_permitted_parameters
    policy = Pundit.policy(current_user || User.new, User)
    devise_parameter_sanitizer
      .permit(:account_update,
              keys: policy.permitted_attributes_for_account_update)
    devise_parameter_sanitizer
      .permit(:invite, keys: policy.permitted_attributes_for_create)
    devise_parameter_sanitizer
      .permit(:accept_invitation, keys: policy.permitted_attributes)
  end

  def user_not_authorized
    respond_to do |format|
      format.html do
        flash[:alert] = 'You are not authorized to perform this action.'

        redirect_to(request.referer || root_path)
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

  def enforce_verification
    return if current_user.verified? || devise_controller?

    redirect_to verify_path
  end

  def enforce_covid_19_vaccinated
    return unless current_user.require_covid_19_vaccinated?
    return if current_user.covid_19_vaccinated? || devise_controller?

    redirect_to vaccination_status_path
  end
end
