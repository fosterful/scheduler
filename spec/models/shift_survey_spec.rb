require 'rails_helper'

RSpec.describe ShiftSurvey, type: :model do
  let(:shift_survey) { create :shift_survey }
  
  it 'has a valid factory' do
    expect(shift_survey.valid?).to be(true)
  end

  describe 'generate_token' do
    it 'generates a unique token' do
      shift_survey.generate_token
      expect(shift_survey.token).not_to be_nil
    end
  end

end