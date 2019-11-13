class OptoutsController < ApplicationController
  def create
    @need = Need.find(params[:need_id])
    @optout = current_user.optouts.build(need: @need)

    authorize @optout

    @optout.save
    redirect_to @need
  end
end
