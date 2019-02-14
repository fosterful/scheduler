# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Office, type: :model do
  let(:office) { build :office }

  it 'has a valid factory' do
    expect(office.valid?).to be(true)
  end
  context 'scope' do
    let(:office1) { build(:office, name: Faker::Company.name) }
    let(:office2) { build(:office, name: Faker::Company.name) }
    let(:office3) { build(:office, name: Faker::Company.name) }
    let(:office4) { build(:office, name: Faker::Company.name) }
    let(:addr1) { create(:address, :wa, addressable: office1) }
    let(:addr2) { create(:address, :or, addressable: office2) }
    let(:addr3) { create(:address, :wa, addressable: office3) }
    let(:addr3) { create(:address, :wa, addressable: office4) }
    let!(:need1) { create(:need_with_shifts, expected_duration: 120, office: office1) }
    let!(:need2) { create(:need_with_shifts, expected_duration: 120, office: office2) }
    let!(:need3) { create(:need_with_shifts, expected_duration: 120, office: office3) }
    let!(:need4) { create(:need_with_shifts, expected_duration: 120, office: office4) }
    let(:user1) { create(:user, offices: [office1]) }
    let(:user2) { create(:user, offices: [office2]) }
    let(:user3) { create(:user, offices: [office3]) }

    describe '.volunteer_minutes' do
      it 'returns the total volunteer minutes grouped by office' do
        expect(Office.volunteer_minutes).to eql(office1.id =>120, office2.id => 120, office3.id => 120, office4.id => 120)
      end
    end

    describe '.volunteer_minutes_by_state' do
      it 'returns the total volunteer minutes groupe by state' do
        expect(Office.volunteer_minutes_by_state).to eql(addr1.state => 360, addr2.state => 120)
      end
    end

    describe '.volunteer_minutes_by_county' do
      it 'returns the total volunteer minutes grouped by county' do
        expect(Office.volunteer_minutes_by_county('WA')).to eql(addr1.county => 240, addr3.county => 120)
      end
    end

    describe '.children_served' do
      it 'does something' do
        expect(Office.children_served).to be nil
      end
    end

    describe '.children_served_by_state' do
      it 'does something' do
        expect(Office.children_served_by_state).to be nil
      end
    end

    describe '.children_served_by_county' do
      it 'does something' do
        expect(Office.children_served_by_county('WA')).to be nil
      end
    end

    describe '.children_by_demographic' do
      it 'does something' do
        expect(Office.children_by_demographic).to be nil
      end
    end

    describe '.volunteers_by_demographic' do
      it 'does something' do
        expect(Office.volunteers_by_demographic).to be nil
      end
    end
  end
end
