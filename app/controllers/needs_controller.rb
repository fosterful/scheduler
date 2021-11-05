# frozen_string_literal: true

class NeedsController < ApplicationController
  before_action :check_need_creation_disabled?, only: %i(new create edit update)

  def index
    authorize Need

    @needs = policy_scope(Need).includes(:shifts).order(:start_at)

    if current_user.admin? && params[:date]
      @date = Date.parse(params[:date])
      @needs = @needs.on_date(@date)
    else
      @date = nil
      @needs = @needs.current
    end
  end

  def show
    @need   = policy_scope(Need).includes(:shifts).find(params[:id])
    @shifts = @need.shifts.order(:start_at)

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

    if @need.valid? && @need.update(shifts: Services::BuildNeedShifts.call(@need))
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
    
    if params[:need][:children_attributes].select { |_, v| v[:_destroy] == ''}.keys.any?
      if @need.save
        Services::Notifications::Needs.new(@need, :update).notify
        redirect_to(@need)
      else
        render(:edit)
      end
    else
      flash.now[:error] = 'A need must include at least one child.'
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

  def mark_unavailable
    @need = policy_scope(Need).find(params[:id])
    authorize @need
    @need.unavailable_user_ids << current_user.id
    @need.save
    redirect_to @need
  end

  def office_social_workers
    office = policy_scope(Office).where(id: params[:office_id]).first
    render layout: false, locals: { office: office }
  end

  private

  def check_need_creation_disabled?
    return unless need_creation_disabled?

    flash[:error] = redis.get('need_creation_disabled_msg').presence || 'Need creation disabled'
    redirect_to root_path
  end

  def convert_to_minutes!
    return unless params[:need] && params[:need][:expected_duration].present?

    params[:need][:expected_duration] = (params[:need][:expected_duration].to_f * 60).to_s
  end
end
