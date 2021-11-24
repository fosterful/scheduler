require 'rails_helper'

RSpec.describe ShiftSurveyPolicy,
 type: :policy do

  subject { described_class.new(user, shift_survey) }
  let(:creator) { build :user, role: 'social_worker' }
  let(:user) { creator }
  let(:record) { build :shift, user: creator }
  let(:shift_survey) { build :shift_survey, user: creator }

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = subject.permitted_attributes

      expect(result).to eql([
      :notes,
      :need_id,
      :user_id,
      :survey_id,
      :status,
      :supplies,
      :response_time,
      :hours_match,
      :supplies_text,
      :response_time_text,
      :hours_match_text,
      :ratings_text,
      :comments,
      :questions,
      :ratings => []
      ])
    end
  end

end
