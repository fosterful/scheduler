# frozen_string_literal: true

class ShiftsController < ApplicationController

  def index
    @need   = policy_scope(Need)
                .includes(shifts: :user)
                .includes(:office)
                .find(params[:need_id])
    @shifts = @need.shifts.order(:start_at)

    authorize @shifts.first
  end

  def create
    @need  = policy_scope(Need).find(params[:need_id])
    @shift = @need.shifts.build(permitted_attributes(Shift))

    authorize @shift

    if @shift.save
      Services::ShiftNotifications::Create.call(@shift, need_url(@need))
      flash[:notice] = 'Shift Successfully Created!'
    else
      flash[:alert] = DEFAULT_ERROR
    end
    redirect_to need_shifts_path(@need)
  end

  def update
    @need  = policy_scope(Need).find(params[:need_id])
    @shift = policy_scope(Shift).find(params[:id])

    authorize @shift

    user_id_was = @shift.user_id
    @shift.assign_attributes(permitted_attributes(@shift))

    if @shift.save
      Services::ShiftNotifications::Update
        .call(@shift, current_user, user_id_was)
      flash[:notice] = if permitted_attributes(@shift).fetch('user_id').present?
                         'Shift Claimed!'
                       else
                         'Shift Released!'
                       end
    else
      flash[:alert] = DEFAULT_ERROR
    end
    redirect_to params[:redirect_to] || @need
  end

  def destroy
    @need  = policy_scope(Need).find(params[:need_id])
    @shift = policy_scope(Shift).find(params[:id])

    authorize @shift

    if @shift.can_destroy? && @shift.destroy
      Services::ShiftNotifications::Destroy.call(@shift, need_url(@need))
      flash[:notice] = 'Shift Successfully Destroyed'
    else
      flash[:alert] = @shift
                        .errors
                        .full_messages
                        .first
                        .presence || DEFAULT_ERROR
    end
    redirect_to need_shifts_path(@need)
  end
end
