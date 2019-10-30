# frozen_string_literal: true

class ShiftsController < ApplicationController
  DEFAULT_ERROR = 'Whoops! Something went wrong.'
  private_constant :DEFAULT_ERROR

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
      Services::Notifications::Shifts.new(@shift, :create).notify

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

    user_was = @shift.user
    @shift.assign_attributes(permitted_attributes(@shift))

    if @shift.save
      Services::Notifications::Shifts
        .new(@shift, :update, update_event_data(user_was))
        .notify

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
      Services::Notifications::Shifts.new(@shift, :destroy).notify

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

  private

  def update_event_data(user_was)
    { current_user: current_user, user_was: user_was }
  end
end
