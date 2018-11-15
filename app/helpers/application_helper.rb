module ApplicationHelper
  def flash_classes
    { notice: 'success', error: 'alert', alert: 'warning' }.with_indifferent_access
  end
end
