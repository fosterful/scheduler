# frozen_string_literal: true

ActiveAdmin.register Race do

  config.sort_order = 'id_asc'

  filter :id
  filter :name

  #:nocov:
  index do
    id_column
    column :name
    actions
  end
  #:nocov:

  menu priority: 4
end
