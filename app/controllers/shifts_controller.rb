# frozen_string_literal: true

class ShiftsController < ApplicationController
  def index
    @need = policy_scope(Need).includes(shifts: :user).includes(:office).find(params[:need_id])
    @shifts = @need.shifts.order(:start_at)
    authorize @shifts.first
  end

  def new
    @need = policy_scope(Need).includes(:shifts).find(params[:need_id])
    @shift = @need.shifts.build
    authorize @shift
  end

  def create
    @need = policy_scope(Need).find(params[:need_id])
    @shift = @need.shifts.build(permitted_attributes(Shift))
    authorize @shift
    if @shift.save
      redirect_to need_path(@need)
    else
      render(:new)
    end
  end

  def update
    @need = policy_scope(Need).find(params[:need_id])
    @shift = policy_scope(Shift).find(params[:id])
    authorize @shift
    @shift.assign_attributes(permitted_attributes(@shift))
    if @shift.save
      Services::SendShiftStatusNotifications.call(@shift)
      flash[:notice] = 'Shift Claimed!'
    else
      flash[:alert] = 'Whoops! something went wrong.'
    end
    redirect_to params[:redirect_to] || @need
  end

  def destroy
    @need = policy_scope(Need).find(params[:need_id])
    @shift = policy_scope(Shift).find(params[:id])
    authorize @shift
    if @shift.destroy
      Services::SendShiftStatusNotifications.call(@shift)
      flash[:notice] = 'Shift Successfully Destroyed'
    else
      flash[:alert] = 'Whoops! something went wrong.'
    end
    redirect_to need_shifts_path(@need)
  end
end
