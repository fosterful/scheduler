# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationConcern do

  let(:need) { create(:need).extend(described_class) }
  let(:users) { User.all }
  let(:user) { need.user }

  describe '#scope_users_by_language' do
    it 'scope_users_by_language when no matches' do
      need.preferred_language = create(:language, name: 'French')
      need.save!

      result = need.scope_users_by_language(users)

      expect(result).to match_array([])
    end

    it 'scope_users_by_language' do
      result = need.scope_users_by_language(users)

      expect(result).to match_array([user])
    end
  end

  describe '#scope_users_by_age_ranges' do
    it 'scope_users_by_age_ranges when no matches' do
      result = need.scope_users_by_age_ranges(users)

      expect(result).to match_array([])
    end

    it 'scope_users_by_age_ranges' do
      user.age_range_ids = need.age_range_ids
      user.save!

      result = need.scope_users_by_age_ranges(users)

      expect(result).to match_array([user])
    end
  end

end
