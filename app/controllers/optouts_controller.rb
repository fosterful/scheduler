class OptoutsController < ApplicationController
  def create
    @need = Need.find(params[:need_id])
    @optout = current_user.optouts.build(need: @need)

    authorize @optout

    @optout.save
    redirect_to @need
  end

  def update
    @need = Need.find(params[:need_id])
    @optout = Optout.find(params[:id])

    authorize @optout

    @optout.update_shift_times
    redirect_to @need
  end
end
