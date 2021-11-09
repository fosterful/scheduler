require 'rails_helper'
RSpec.describe ShiftSurveyWorker do

  describe '#perform' do
    subject { -> { described_class.new.perform } }

    it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }

    context 'when there are completed shifts' do
      let(:office) { create :office }
      let(:user) { create :user, role: 'coordinator', offices: [office] }
      let(:volunteer) { create :user, role: 'volunteer', offices: [office] }
      let(:need) { create :need_with_assigned_shifts, user: user, office: office }
      let(:shift) { need.shifts.first }
      let(:shift_survey) { create :shift_survey, shift: shift }

      before do
        create(:shift, need: need, start_at: 3.hours.ago,
          created_at: 4.hours.ago, user: volunteer)
      end
      
      it { is_expected.to change(SendTextMessageWorker.jobs, :size) }
      
    end
  end

end

