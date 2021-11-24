require 'rails_helper'

RSpec.describe ShiftSurvey, type: :model do
  let(:shift_survey) { create :shift_survey }
  let(:user) { create :user }
  
  it 'has a valid factory' do
    expect(shift_survey.valid?).to be(true)
  end

  describe 'generate_token' do
    it 'generates a unique token' do
      shift_survey.generate_token
      expect(shift_survey.token).not_to be_nil
    end
  end

  describe 'to_param' do
    it 'generates a link based on the token' do
      expect(shift_survey.to_param).to eq(shift_survey.token)
    end
  end

  describe 'survey_responses_by_shift' do
    it 'returns a hash of responses by shift' do
      ShiftSurvey.survey_responses_by_shift(user, Date.yesterday.to_s, Date.tomorrow.to_s).each do |shift, responses|
        expect(responses.count).to eq(shift.survey_responses.count)
      end
    end
  end

end