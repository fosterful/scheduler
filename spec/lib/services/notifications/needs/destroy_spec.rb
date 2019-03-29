# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Destroy do
  subject { described_class.call(need) }

  let(:office) { create(:office) }
  let(:scheduler) { create(:user, role: 'social_worker', offices: [office]) }
  let(:need) { create(:need_with_shifts, office: office, user: scheduler) }
  let(:volunteer) { create(:user, offices: [office]) }
  let!(:other_volunteer) { create(:user, offices: [office]) }

  describe '#call' do
    it 'includes the office schedulers and users signed up for shifts' do
      need.shifts.last.update(user: volunteer)

      expect(subject).to contain_exactly(scheduler, volunteer)
    end
  end

end
