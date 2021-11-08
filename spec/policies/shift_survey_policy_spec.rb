require 'rails_helper'

RSpec.describe ShiftSurveyPolicy, type: :policy do

  subject { described_class.new(user, shift_survey) }
  let(:user) { creator }
  let(:creator) { build :user, role: 'social_worker' }
  let(:record) { build :shift, user: creator }
  let(:shift_survey) { build :shift_survey, shift: record }

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = subject.permitted_attributes

      expect(result).to eql([:notes, :shift_id, :survey_id, :status, :supplies, :response_time, :hours_match, :ratings, :ratings_text, :comments, :questions])
    end
  end

end
