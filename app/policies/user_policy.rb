class UserPolicy
  attr_reader :user, :other_user

  def initialize(user, other_user)
    @user = user
    @other_user = other_user
  end

  def invite?
    case user.role
    when 'admin'
      true
    when 'coordinator'
      other_user.role.in? %w[volunteer social_worker]
    when 'social_worker'
      other_user.role.in? %w[volunteer]
    else
      false
    end
  end
end
