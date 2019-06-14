# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Message::Create do
  subject { described_class.new(need, notifier).call }

  let(:notifier) { double }
  let(:need) do
    create(:need, start_at: Date.parse('2019-05-23')).tap do |need|
      need.update(shifts: Services::BuildNeedShifts.call(need))
    end
  end
  let(:msg) do
    'A new need starting Thu, May 23 at 12:00am has opened up at your local '\
      "office! http://localhost:3000/needs/#{need.id}"
  end
  let(:volunteer) { build(:user, age_ranges: need.age_ranges) }
  let(:social_worker) { build(:social_worker, age_ranges: need.age_ranges) }

end
