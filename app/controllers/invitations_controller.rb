class InvitationsController < Devise::InvitationsController
  before_action :authorize_role, only: :new

  private

  def authorize_role
    return if params.dig(:user, :role).in? User::REGISTERABLE_ROLES
    redirect_to root_path, flash: { error: 'User role is required.' }
  end
end
