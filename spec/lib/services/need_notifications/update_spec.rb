# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::NeedNotifications::Update do
  let(:need) do
    build(:need).tap do |need|
      need.update(shifts: Services::BuildNeedShifts.call(need))
    end
  end

  let(:user) { build(:user) }

  subject { described_class.call(need) }

end