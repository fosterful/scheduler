# frozen_string_literal: true

class NeedsController < ApplicationController
  def index
    authorize Need
    @needs = policy_scope(Need).includes(:shifts).order(:start_at)
  end

  def show
    @need = policy_scope(Need).includes(:shifts).find(params[:id])
    @shifts = @need.shifts
    authorize @need
  end

  def new
    @need = Need.new
    authorize @need
  end

  def create
    @need = current_user.needs.build(permitted_attributes(Need))
    authorize @need
    if @need.update(shifts: Services::BuildNeedShifts.call(@need))
      Services::SendNeedNotifications.call(@need)
      redirect_to(@need)
    else
      render(:new)
    end
  end

  def edit
    @need = policy_scope(Need).find(params[:id])
    authorize @need
  end

  def update
    @need = policy_scope(Need).find(params[:id])
    @need.assign_attributes(permitted_attributes(@need))
    authorize @need
    if @need.save
      Services::SendNeedNotifications.call(@need)
      redirect_to(@need)
    else
      render(:edit)
    end
  end

  def destroy
    @need = policy_scope(Need).find(params[:id])
    authorize @need
    if @need.destroy
      redirect_to needs_path, flash: { success: 'Need successfully deleted' }
    else
      redirect_back fallback_location: needs_path, flash: { error: 'Failed to delete Need' }
    end
  end
end
