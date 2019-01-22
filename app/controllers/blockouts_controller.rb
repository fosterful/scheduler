# frozen_string_literal: true

class BlockoutsController < ApplicationController
  def create
    @blockout = current_user.blockouts.build(permitted_attributes(Blockout))
    authorize @blockout
    respond_with_json do
      if Services::ExpandRecurringBlockout.call(@blockout)
        render json: @blockout
      else
        render json: { error: @blockout.errors.full_messages.to_sentence }, status: 422
      end
    end
  end

  def update
    @blockout = current_user.blockouts.find(params[:id])
    @blockout.assign_attributes(permitted_attributes(Blockout))
    authorize @blockout
    respond_with_json do
      if Services::ExpandRecurringBlockout.call(@blockout)
        render json: @blockout
      else
        render json: { error: @blockout.errors.full_messages.to_sentence }, status: 422
      end
    end
  end

  def destroy
    @blockout = current_user.blockouts.find(params[:id])
    authorize @blockout
    @blockout.destroy!
    respond_with_json do
      render json: {}, status: 200
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