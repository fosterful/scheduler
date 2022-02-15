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

end
