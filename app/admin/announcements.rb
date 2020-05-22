ActiveAdmin.register Announcement do
  permit_params :message

  actions :index, :show, :new, :create

  before_create do |annoucement|
    annoucement.author = current_user
    annoucement.user_ids = User.with_phone.pluck(:id)
  end

  after_create do |announcement|
    announcement.send_messages
  end

  config.sort_order = 'created_at_desc'

  #:nocov:
  index do
    id_column
    column :message
    column :author
    column :user_ids
    actions
  end
  #:nocov:

  form do |f|
    f.semantic_errors
    f.input :message
    f.actions
  end

  menu priority: 7
end
