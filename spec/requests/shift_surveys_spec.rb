# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shift Surveys', type: :request do

  let(:office) { create :office }
  let(:user) { create :user, role: 'coordinator', offices: [office] }
  let(:volunteer) { create :user, role: 'volunteer', offices: [office] }
  let(:need) { create :need_with_assigned_shifts, user: user, office: office }
  let(:shift) { need.shifts.first }
  let(:shift_survey) { create :shift_survey, shift: shift }
  
  describe '#show' do
    context "when survey exists and is incomplete" do
      it 'renders the survey' do
        get "/shift_surveys/#{shift_survey.token}"
        expect(response).to render_template(:show)
      end
    end

    context "when survey exists and is complete" do
      it 'renders thanks' do
        shift_survey.update(status: "Complete")
        get "/shift_surveys/#{shift_survey.token}"
        expect(response).to render_template(:thanks)
      end
    end
    
    context "when token is invalid" do
      it 'renders invalid' do
        get "/shift_surveys/invalid-token"
        expect(response).to render_template(:invalid)
      end
    end
    
  end
  
  describe '#update' do
    context 'when success' do
      it 'changes status to "Complete"' do
        expect(shift_survey.status).to eq("Incomplete")
        put "/shift_surveys/#{shift_survey.token}",
          params: { "shift_survey"=>{"notes"=>"Updated Notes", "ratings"=>[]}} 
        expect(shift_survey.reload.notes).to eql("Updated Notes")
        expect(shift_survey.reload.status).to eql("Complete")
        expect(response).to render_template(:thanks)
      end
    end
    
    context 'when fail' do
      it 'renders show' do
        shift_survey
        expect_any_instance_of(ShiftSurvey).to receive(:save).and_return(false)
        put "/shift_surveys/#{shift_survey.token}",
          params: { "shift_survey"=>{"notes"=>"Updated Notes", "ratings"=>[]}}
        expect(flash[:notice]).to eql("Error")
        expect(response).to render_template(:show)
      end
    end
  end



end
