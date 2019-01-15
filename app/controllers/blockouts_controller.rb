class BlockoutsController < ApplicationController
  def create
    @blockout = current_user.blockouts.build(permitted_attributes(Blockout))
    respond_with_json do
      if Services::ExpandRecurringBlockout.call(@blockout)
        render json: @blockout
      else
        render json: @blockout.errors
      end
    end
  end

  private

  def respond_with_json
    respond_to do |format|
      format.json do
        yield
      end
    end
  end
end