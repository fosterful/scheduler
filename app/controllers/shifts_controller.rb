# frozen_string_literal: true

class ShiftsController < ApplicationController
  def index
    authorize Shift
  end

  def new
    @need = policy_scope(Need).find(params[:need_id])
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
    @shift = policy_scope(Shift).find(params[:id])
    @need = policy_scope(Need).find(params[:need_id])
    authorize @shift
    @shift.assign_attributes(permitted_attributes(@shift))
    if @shift.save
      Services::SendShiftStatusNotifications.call(@shift)
      flash[:notice] = 'Shift Claimed!'
    else
      flash[:alert] = 'Whoops! something went wrong.'
    end
    redirect_to @need
  end

  def destroy
    @shift = policy_scope(Shift).find(params[:id])
    authorize @shift
  end
end
