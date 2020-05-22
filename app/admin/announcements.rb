# frozen_string_literal: true

ActiveAdmin.register Announcement do
  config.sort_order = 'created_at_desc'

  actions :index, :show, :new, :create

  before_create do |annoucement|
    annoucement.author   = current_user
    annoucement.user_ids = User.announceable.pluck(:id)
  end

  after_create(&:send_messages)

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
