class InvitationPolicy
  attr_reader :user, :invitee

  def initialize(user, invitee)
    @user = user
    @invitee = invitee
  end

  def invite?
    case user.role
    when 'admin'
      true
    when 'coordinator'
      invitee.role.in? %w[volunteer social_worker]
    when 'social_worker'
      invitee.role.in? %w[volunteer]
    else
      false
    end
  end
end
