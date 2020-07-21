# frozen_string_literal: true

class DashboardController < ApplicationController
  def reports
    authorize current_user
  end
end
