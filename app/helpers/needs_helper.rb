# frozen_string_literal: true

module NeedsHelper
  def race_options_for_select
    Race.pluck(:name, :id)
  end
end
