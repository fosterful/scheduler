# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::NeedNotifications::Destroy do
  let(:need) do
    build(:need).tap do |need|
      need.update(shifts: Services::BuildNeedShifts.call(need))
    end
  end

  let(:user) { create(:user) }

  subject { described_class.call(need, [user.id]) }

end