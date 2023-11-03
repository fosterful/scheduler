# frozen_string_literal: true

ActiveAdmin.register Announcement do
  config.sort_order = 'created_at_desc'

  actions :index, :show, :new, :create
  form partial: 'form'

  before_create do |announcement|
    announcement.author   = current_user
    announcement.user_ids = announcement.user_ids.compact.presence ||
      User.announceable.pluck(:id)
  end

  after_create(:send_messages)

  # :nocov:
  index do
    id_column
    column :message
    column :author
    column :user_ids
    actions
  end
  # :nocov:

  menu priority: 7

  controller do
    def send_messages(announcement)
      announcement.send_messages if announcement.persisted?
    end
  end
end
