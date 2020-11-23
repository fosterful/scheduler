# frozen_string_literal: true

ActiveAdmin.register Office do

  config.sort_order = 'id_asc'

  filter :name
  filter :region
  filter :address

  form partial: 'form'

  #:nocov:
  index do
    id_column
    column :name
    column :region
    column :address
    actions
  end
  #:nocov:

  menu priority: 2

  controller do
    def new
      super do
        resource.build_address if resource.address.blank?
      end
    end
  end
end
