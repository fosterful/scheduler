# frozen_string_literal: true

ActiveAdmin.register ShiftSurvey do

  config.sort_order = 'id_asc'

  #:nocov:
  form do |f|
    f.semantic_errors
    inputs 'Details' do
      input :status, as: :select, collection: ['Incomplete', 'Complete']
    end
    f.actions
  end
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

  show do 
    attributes_table do
      row :id
      row :notes
      row :date do |shift_survey|
        shift_survey.shift.start_at.strftime("%A, %B %d, %Y")
      end
      row :name do |shift_survey|
        shift_survey.shift.user.name
      end
      row :need do |shift_survey|
        table_for shift_survey.shift.need do
          column :id
          column :number_of_children
        end
      end
      row :shifts do
        table_for shift_survey.shift.user_need_shifts do
          column :id
          column 'Duration' do |s|
            s.duration_in_words
          end
        end
      end
      row :status
    
      row :created_at
      row :updated_at
    end
  end
  #:nocov:

  menu priority: 9
end