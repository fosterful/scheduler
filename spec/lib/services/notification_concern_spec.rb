# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::NotificationConcern do

  # TODO: auto-generated
  describe '#scope_users_by_language' do
    it 'scope_users_by_language' do
      notification_concern = described_class.new
      users = double('users')
      result = notification_concern.scope_users_by_language(users)

      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#scope_users_by_age_ranges' do
    it 'scope_users_by_age_ranges' do
      notification_concern = described_class.new
      users = double('users')
      result = notification_concern.scope_users_by_age_ranges(users)

      expect(result).not_to be_nil
    end
  end

end
