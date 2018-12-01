module ApplicationHelper
  def flash_classes
    { notice: 'success', error: 'alert', alert: 'warning' }.with_indifferent_access
  end

  def invite_links
    title_map = {
      'coordinator' => 'Volunteer Coordinator'
    }
    User::REGISTERABLE_ROLES.map do |role|
      u = User.new(role: role)
      link_to title_map[role] || role.titleize, new_user_invitation_path(user: { role: role }) if policy(u).new?
    end.compact.to_sentence(last_word_connector: ' or ')
  end
end
