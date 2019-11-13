# frozen_string_literal: true

class NeedsController < ApplicationController
  def index
    authorize Need

    @needs = policy_scope(Need).includes(:shifts).current.order(:start_at)
  end

  def show
    @need   = policy_scope(Need).includes(:shifts).find(params[:id])
    @shifts = @need.shifts.order(:start_at)
    @optout = current_user.optouts.find_or_initialize_by(need: @need)
    if policy(@need).view_optouts?
      @optouts = @need.optouts
      @pending_users = @need.users_pending_response
    end

    authorize @need
  rescue ActiveRecord::RecordNotFound
    redirect_to(root_path, alert: "Sorry, we couldn't find that need.")
  end

  def new
    @need = Need.new

    authorize @need
  end

  def create
    convert_to_minutes!
    @need = current_user.needs.build(permitted_attributes(Need))

    authorize @need

    if @need.update(shifts: Services::BuildNeedShifts.call(@need))
      Services::Notifications::Needs.new(@need, :create).notify

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
      notify_users_of_update

      redirect_to(@need)
    else
      render(:edit)
    end
  end

  def destroy
    @need = policy_scope(Need).find(params[:id])

    authorize @need

    if @need.destroy
      Services::Notifications::Needs.new(@need, :destroy).notify

      redirect_to needs_path, flash: { success: 'Need successfully deleted' }
    else
      redirect_back fallback_location: needs_path,
                    flash:             { error: 'Failed to delete Need' }
    end
  end

  private

  def convert_to_minutes!
    return unless params[:need] && params[:need][:expected_duration].present?

    params[:need][:expected_duration] = (params[:need][:expected_duration].to_f * 60).to_s
  end

  def notify_users_of_update
    Services::Notifications::Needs.new(@need, :update).notify do |notifier|
      @need.notified_user_ids |= notifier.recipients.map(&:id)
      @need.save!
    end
  end

end
