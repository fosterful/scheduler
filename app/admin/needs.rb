# frozen_string_literal: true

ActiveAdmin.register Need do

  config.sort_order = 'id_asc'

  filter :id
  filter :office_id
  filter :user_id

  #:nocov:
  index do
    id_column
    column :start_at
    column :expected_duration
    column :number_of_children
    column :notified_user_ids
    column :race
    column :language
    column :user
    column :office
    actions
  end
  #:nocov:

  menu priority: 3

  # controller do
  #   def new
  #     super do
  #       resource.build_need if resource.need.blank?
  #     end
  #   end
  # end

end
