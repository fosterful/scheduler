# frozen_string_literal: true

class ShiftSurveysController < ApplicationController
  skip_before_action :authenticate_user!

  def show
    @shift_survey = ShiftSurvey.find_by(token: params[:token])
    if @shift_survey.nil?
      flash[:notice] = 'Invalid survey token'
      redirect_to root_path
      return
    end
    
    if @shift_survey.status == "Complete"
      flash[:notice] = 'You have already submitted your survey'
      render 'thanks'
    end
  end

  def update
    @shift_survey = ShiftSurvey.find_by(token: params[:token])
    ["supplies", "response_time", "hours_match"].each do |field|
      if params[:shift_survey]["#{field}"] === "true"
        params[:shift_survey]["#{field}_text"] = ""
      end
    end
    params[:shift_survey][:ratings] = params[:shift_survey][:ratings].select {|feeling| feeling.present?}
    @shift_survey.assign_attributes(permitted_attributes(@shift_survey))
    if @shift_survey.save
      @shift_survey.update(status: "Complete")
      render 'thanks'
    else
      flash[:notice] = 'Error'
      render 'show'
    end
  end

end