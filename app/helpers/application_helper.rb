module ApplicationHelper
  def flash_classes
    { notice: 'success', error: 'alert', alert: 'warning' }.with_indifferent_access
  end

  def invite_links
    User::REGISTERABLE_ROLES.map do |role|
      link_to role.titleize, new_user_invitation_path(user: { role: role })
    end.to_sentence(last_word_connector: ' or ')
  end
end
