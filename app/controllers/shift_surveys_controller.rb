# frozen_string_literal: true

class ShiftSurveysController < ApplicationController
  skip_before_action :authenticate_user!

  def index
    @shift_surveys = ShiftSurvey.all
  end

  def show
    @shift_survey = ShiftSurvey.find_by(token: params[:token])
    @user_need_shifts = @shift_survey.shift.user.shifts.where(need_id: @shift_survey.shift.need_id)

    if @shift_survey.nil?
      flash[:notice] = 'Invalid token'
      render 'invalid'
    end

    if @shift_survey.status == 1
      flash[:notice] = 'You have already submitted your survey'
      render 'thanks'
    end
  end

  def new
    @shift_survey = ShiftSurvey.new
  end

  def create
    @shift_survey = ShiftSurvey.new(shift_survey_params)
    @shift_survey.update(status: "Complete")
    if @shift_survey.save
      redirect_to @shift_survey
    else
      render 'new'
    end
  end

  def edit
    @shift_survey = ShiftSurvey.find_by(token: params[:token])
  end

  def update
    @shift_survey = ShiftSurvey.find_by(token: params[:token])
    @shift_survey.assign_attributes(permitted_attributes(@shift_survey))
    if @shift_survey.save
      @shift_survey.update(status: 1)
      render 'thanks'
    else
      flash[:notice] = 'Error'
      render 'edit'
    end
  end

  def destroy
    @shift_survey = ShiftSurvey.find(params[:id])
    @shift_survey.destroy
    redirect_to shift_surveys_path
  end

  private

  def shift_survey_params
    params.require(:shift_survey).permit(:shift_id, :survey_id)
  end
end