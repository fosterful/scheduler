# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Shift Surveys', type: :request do

  let(:office) { create :office }
  let(:user) { create :user, role: 'coordinator', offices: [office] }
  let(:volunteer) { create :user, role: 'volunteer', offices: [office] }
  let(:need) { create :need_with_assigned_shifts, user: user, office: office }
  let(:shift) { need.shifts.first }
  let(:shift_survey) { create :shift_survey, shift: shift }
  
  describe '#edit' do
    context "when survey exists and is incomplete" do
      it 'renders the survey' do
        get "/shift_surveys/#{shift_survey.token}/edit"
        expect(response).to render_template(:edit)
      end
    end

    context "when survey exists and is complete" do
      it 'renders thanks' do
        shift_survey.update(status: "Complete")
        get "/shift_surveys/#{shift_survey.token}/edit"
        expect(response).to render_template(:thanks)
      end
    end
    
    context "when token is invalid" do
      it 'gives a flash notice of invalid' do
        get "/shift_surveys/invalid-token/edit"
        expect(response).to redirect_to root_path
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
      it 'renders edit' do
        shift_survey
        expect_any_instance_of(ShiftSurvey).to receive(:save).and_return(false)
        put "/shift_surveys/#{shift_survey.token}",
          params: { "shift_survey"=>{"notes"=>"Updated Notes", "ratings"=>[]}}
        expect(flash[:notice]).to eql("Error")
        expect(response).to render_template(:edit)
      end
    end

    context 'when data is entered in text boxes and yes is selected' do
      it 'does not save the data in the text box' do
        shift_survey
        put "/shift_surveys/#{shift_survey.token}",
          params: { "shift_survey"=>{"notes"=>"Updated Notes",
           "ratings"=>[1],
           "supplies" => "true",
           "response_time" => "true",
           "hours_match" => "true",
           "supplies_text" => "text that should not be saved",
           "response_time_text" => "text that should not be saved",
           "hours_match_text" => "text that should not be saved" }}
        expect(shift_survey.reload.hours_match).to eql(true)
        expect(shift_survey.reload.hours_match_text).to eql("")
        expect(shift_survey.reload.supplies).to eql(true)
        expect(shift_survey.reload.supplies_text).to eql("")
        expect(shift_survey.reload.response_time).to eql(true)
        expect(shift_survey.reload.response_time_text).to eql("")
      end
    end
  end



end
