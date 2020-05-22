# frozen_string_literal: true

class Announcement < ApplicationRecord
  belongs_to :author

  validates :message, presence: true
  validates :author_id, presence: true
  validates :user_ids, presence: true
end
