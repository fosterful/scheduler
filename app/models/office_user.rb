# frozen_string_literal: true

class OfficeUser < ApplicationRecord
  belongs_to :office
  belongs_to :user
end
