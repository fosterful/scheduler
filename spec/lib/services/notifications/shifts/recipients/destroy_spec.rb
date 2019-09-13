# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Shifts::Recipients::Destroy do

  let(:object) { described_class.new(shift, event_data) }
  let(:event_data) { {} }
  let(:shift) { create(:shift) }
  let!(:volunteer) { create(:user).tap { |u| shift.office.users << u } }

  describe '#recipients' do
    it 'returns empty array if shift not assigned' do
      expect(object.recipients).to eql([])
    end

    it 'returns shift user if shift assigned' do
      shift.user = volunteer

      expect(object.recipients).to eql([volunteer])
    end
  end

end
