# frozen_string_literal: true

ActiveAdmin.register Language do

  config.sort_order = 'id_asc'

  filter :name
  filter :id
  filter :name

  #:nocov:
  index do
    id_column
    column :name
    actions
  end
  #:nocov:

  menu priority: 6
end
