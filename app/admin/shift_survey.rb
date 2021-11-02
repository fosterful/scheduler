# frozen_string_literal: true

ActiveAdmin.register ShiftSurvey do

  config.sort_order = 'id_asc'

  #:nocov:
  index do
    id_column
    column "User" do |shift_survey|
      shift_survey.shift.user.name
    end
    column :status
    column :created_at
    column :updated_at
    actions
  end
  #:nocov:

  menu priority: 9
end