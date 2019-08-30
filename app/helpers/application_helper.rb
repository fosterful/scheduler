# frozen_string_literal: true

module ApplicationHelper
  def flash_classes
    { notice: 'success',
      error:  'alert',
      alert:  'warning' }.with_indifferent_access
  end

  def invite_options_for_select
    title_map = {
      'coordinator' => 'Volunteer Coordinator'
    }

    User::ROLES.map do |role|
      u = User.new(role: role)
      [title_map[role] || role.titleize, role] if policy(u).new?
    end.compact
  end

  def offices_for_select(scope)
    scope.offices.map do |o|
      ["#{o} | #{o.address.state} | Region: #{o.region}", o.id]
    end
  end

  def profile_attributes_required?(user)
    user.volunteer? || user.coordinator?
  end
end
