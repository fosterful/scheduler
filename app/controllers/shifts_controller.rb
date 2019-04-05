# frozen_string_literal: true

class ShiftsController < ApplicationController
  def index
    @need   = policy_scope(Need).includes(shifts: :user).includes(:office).find(params[:need_id])
    @shifts = @need.shifts
    authorize @shifts.first
  end

  def create
    @need  = policy_scope(Need).find(params[:need_id])
    @shift = @need.shifts.build(permitted_attributes(Shift))
    authorize @shift
    if @shift.save
      Services::ShiftNotifier.call(@shift, :create)
      flash[:notice] = 'Shift Successfully Created!'
    else
      flash[:alert] = 'Whoops! something went wrong.'
    end
    redirect_to need_shifts_path(@need)
  end

  def update
    @need  = policy_scope(Need).find(params[:need_id])
    @shift = policy_scope(Shift).find(params[:id])
    authorize @shift
    user_was = @shift.user
    @shift.assign_attributes(permitted_attributes(@shift))
    if @shift.save
      Services::ShiftNotifier.call(@shift, :update, current_user, user_was)
      flash[:notice] = 'Shift Claimed!'
    else
      flash[:alert] = 'Whoops! something went wrong.'
    end
    redirect_to params[:redirect_to] || @need
  end

  def destroy
    @need  = policy_scope(Need).find(params[:need_id])
    @shift = policy_scope(Shift).find(params[:id])
    authorize @shift
    if @shift.destroy
      Services::ShiftNotifier.call(@shift, :destroy)
      flash[:notice] = 'Shift Successfully Destroyed'
    else
      flash[:alert] = 'Whoops! something went wrong.'
    end
    redirect_to need_shifts_path(@need)
  end
end
