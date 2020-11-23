# frozen_string_literal: true

ActiveAdmin.register AgeRange do

  config.sort_order = 'id_asc'

  filter :min
  filter :max

  #:nocov:
  index do
    id_column
    column :min
    column :max
    actions
  end
  #:nocov:

  menu priority: 3
end
