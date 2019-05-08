# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Office, type: :model do
  let(:office) { build :office }

  it 'has a valid factory' do
    expect(office.valid?).to be(true)
  end
  context 'reporting' do
    let(:wa_address1) { build(:address, :wa)}
    let(:wa_address2) { build(:address, :wa, county: 'Lewis')}
    let(:wa_office1) { create(:wa_office, address: wa_address1).tap { wa_address1.save!} }
    let(:wa_office2) { create(:wa_office, address: wa_address2).tap { wa_address2.save!} }
    let(:or_office) { create(:or_office) }
    let(:wa_sw1) { create(:user, role: 'social_worker', offices: [wa_office1])}
    let(:wa_sw2) { create(:user, role: 'social_worker', offices: [wa_office2])}
    let(:or_sw) { create(:user, role: 'social_worker', offices: [or_office])}
    let(:wa_user1) { create(:user, offices: [wa_office1]) }
    let(:wa_user2) { create(:user, offices: [wa_office2]) }
    let(:wa_user3) { create(:user, offices: [wa_office2]) }
    let(:or_user) { create(:user, offices: [or_office]) }
    let(:wa_need1) { create(:need_with_shifts, user: wa_sw1, number_of_children: 1, expected_duration: 60, office: wa_office1) }
    let(:wa_need2) { create(:need_with_shifts, user: wa_sw2, number_of_children: 2, expected_duration: 240, office: wa_office2) }
    let(:wa_need3) { create(:need_with_shifts, user: wa_sw2, number_of_children: 7, expected_duration: 60, office: wa_office2) }
    let!(:unmet_wa_need) { create(:need_with_shifts, user: wa_sw2, number_of_children: 2, expected_duration: 120, office: wa_office2) }
    let(:or_need) { create(:need_with_shifts, user: or_sw, number_of_children: 3, expected_duration: 120, office: or_office) }

    before do
      or_need.shifts.first.update(user: or_user) # 3
      wa_need1.shifts.first.update(user: wa_user1) # 1
      wa_need2.shifts.update_all(user_id: wa_user2.id) # 2
      wa_need3.shifts.first.update(user: wa_user3) # 7
    end

    describe '.volunteer_minutes' do
      it 'returns the total volunteer minutes grouped by office' do
        expect(described_class.total_volunteer_minutes_by_office).to eql(or_office.id => 60, wa_office1.id => 60, wa_office2.id => 300)
      end
    end

    describe '.volunteer_minutes_by_state' do
      it 'returns the total volunteer minutes groupe by state' do
        expect(described_class.total_volunteer_minutes_by_state).to eql('OR' => 60, 'WA' => 360)
      end
    end

    describe '.volunteer_minutes_by_county' do
      it 'returns the total volunteer minutes groupe by county' do
        expect(described_class.total_volunteer_minutes_by_county('WA')).to eql('Lewis' => 300, 'Clark' => 60)
      end
    end

    # describe '.children_served' do
    #   it 'returns the total children served grouped by office' do
    #     binding.pry
    #     expect(described_class.children_served).to eql(nil)
    #   end
    # end

    # describe '.children_served_by_state' do
    #   it 'does something' do
    #     expect(described_class.children_served_by_state).to eql(nil)
    #   end
    # end

    # describe '.children_served_by_county' do
    #   it 'does something' do
    #     expect(described_class.children_served_by_county('WA')).to eql(nil)
    #   end
    # end

    # describe '.children_by_demographic' do
    #   it 'does something' do
    #     expect(described_class.children_by_demographic).to eql(nil)
    #   end
    # end

    # describe '.volunteers_by_demographic' do
    #   it 'does something' do
    #     expect(described_class.volunteers_by_demographic).to eql(nil)
    #   end
    # end
  end
end
