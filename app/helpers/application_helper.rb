module ApplicationHelper
  def flash_classes
    { notice: 'success', error: 'alert', alert: 'warning' }.with_indifferent_access
  end

  def sign_up_as_link_html(resource_name)
    User::REGISTERABLE_ROLES.map do |role|
      link_to role.titleize, new_registration_path(resource_name, user: { role: role })
    end.to_sentence(last_word_connector: ' or ')
  end
end
