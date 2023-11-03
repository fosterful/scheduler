# frozen_string_literal: true

class ShiftSurveysController < ApplicationController
  skip_before_action :authenticate_user!

  def edit
    @shift_survey = ShiftSurvey.find_by(token: params[:token])
    if @shift_survey.nil?
      flash[:notice] = 'Invalid survey token'
      redirect_to root_path
      return
    end

    return unless @shift_survey.status == 'Complete'

    flash[:notice] = 'You have already submitted your survey'
    render 'thanks'
  end

  def update
    @shift_survey = ShiftSurvey.find_by(token: params[:token])
    params[:shift_survey][:ratings] = params[:shift_survey][:ratings].select do |feeling|
      feeling.present?
    end
    @shift_survey.assign_attributes(permitted_attributes(@shift_survey))
    if @shift_survey.save
      @shift_survey.update(status: 'Complete')
      UserMailer.with(shift_survey: @shift_survey).shift_survey_submitted.deliver_later
      render 'thanks'
    else
      flash[:notice] = 'Error'
      render 'edit'
    end
  end

end
