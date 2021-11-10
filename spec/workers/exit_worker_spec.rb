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

      before do
        create(:shift, need: need, start_at: 3.hours.ago,
          created_at: 4.hours.ago, user: volunteer)
      end
      it 'creates a shift survey' do
        expect { subject.call }.to change(ShiftSurvey, :count).by(1)
      end
      it { is_expected.to change(SendTextMessageWorker.jobs, :size) }
    end

    context 'when there are no completed shifts' do 
      let(:office) { create :office }
      let(:user) { create :user, role: 'coordinator', offices: [office] }
      let(:volunteer) { create :user, role: 'volunteer', offices: [office] }
      let(:need) { create :need_with_assigned_shifts, user: user, office: office }
      
      before do
        create(:shift, need: need, start_at: 1.hour.from_now,
          created_at: 4.hours.ago, user: volunteer)
      end

      it 'does not create a shift survey' do
        expect { subject.call }.to_not change(ShiftSurvey, :count)
      end
      it { is_expected.not_to change(SendTextMessageWorker.jobs, :size) }

    end
  end

end

