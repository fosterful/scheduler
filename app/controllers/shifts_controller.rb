# frozen_string_literal: true

class ShiftsController < ApplicationController
  def index
    authorize Shift
    @shifts = policy_scope(Shift)
                .includes(need: :office)
                .order(:start_at)
                .where('shifts.start_at >= ?', Time.zone.now)
  end

  def new
  end

  def create
  end

  def update
  end

  def destroy
  end
end
