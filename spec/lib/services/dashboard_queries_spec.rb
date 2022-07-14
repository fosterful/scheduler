# frozen_string_literal: true

require 'rails_helper'

describe Services::DashboardQueries do
  let(:need) { FactoryBot.create(:need_with_assigned_shifts) }
  let(:office_id) { need.office.id.to_s }
  let(:need_created_at_start_date) {
    need.created_at.beginning_of_month.to_date.to_s
  }
  let(:need_created_at_end_date) {
    need.created_at.end_of_month.to_date.to_s
  }
  let(:dashboard_query) { Services::DashboardQueries.new(
      office_id,
      need_created_at_start_date,
      need_created_at_end_date
    )
  }

  describe '#users_by_hours_volunteered' do
    it 'returns a sorted array of hashes, of active record relations, in decending order of hours volunteered' do
      result = dashboard_query.users_by_hours_volunteered

      expect(result).to match([{:email=>String, :hours=>BigDecimal("0.2e1"), :id=>Integer, :name=>"Test User", :role=>"social_worker"}])
    end
  end

  describe '#users_by_needs_created' do
    it 'returns a sorted array of hashes, of active record relations, in decending order of needs created' do
      result = dashboard_query.users_by_needs_created

      expect(result).to match([{:email=>String, :id=>Integer, :name=>"Test User", :needs_created=>1, :role=>"social_worker"}])
    end
  end

  describe '#hours_volunteered' do
    it 'returns an integer which represents all the hours volunteered by all users within the timeframe passed in' do
      result = dashboard_query.hours_volunteered

      expect(result).to eq(2)
    end
  end

  describe '#needs_created' do
    it 'returns an integer which represents all needs created within the timeframe passed in' do
      result = dashboard_query.needs_created

      expect(result).to equal(1)
    end

    context 'finds the proper office id' do
      let!(:need_2) { FactoryBot.create(:need) }

      it 'returns an integer which represents all needs created within the timeframe passed in' do
        result = dashboard_query.needs_created

        expect(result).to equal(1)
      end
    end
  end

  describe '#shifts_created' do
    # Implied that office_id, start_date, and end_date are correct
    it 'returns an integer which represents all shifts created within the timeframe passed in' do
      result = dashboard_query.shifts_created

      expect(result).to equal(2)
    end

    # Implied start_date, and end_date are correct
    context 'when other shift exists that do not belong to the office' do
      let!(:need_2) { FactoryBot.create(:need_with_assigned_shifts) }

      it 'excludes shifts that do not belong to the office' do
        result = dashboard_query.shifts_created

        expect(result).to equal(2)
      end
    end

    # This method is testing that the code does not fail catastrophically,
    # meaning we haven't created code to handle this edge case.
    context 'when start_date is after end_date' do
      let(:need_created_at_start_date) {
        need.created_at.end_of_month.to_date.to_s
      }
      let(:need_created_at_end_date) {
        need.created_at.beginning_of_month.to_date.to_s
      }

      it "returns results with zero's" do
        result = dashboard_query.shifts_created

        expect(result).to equal(0)
      end
    end
  end

  describe '#shift_claimed' do
    let(:need_2) { FactoryBot.create(:need_with_shifts, office: need.office ) }

    it 'returns an integer which represents all shifts claimed by a user within the timeframe passed in' do
      result = dashboard_query.shifts_claimed

      expect(result).to equal(2)
    end

  end

  describe '#shifts_unclaimed' do
    it 'returns an integer which is the difference between shift created and shifts claimed' do
      result = dashboard_query.shifts_unclaimed

      expect(result).to equal(0)
    end

    context 'when shift created is greater than shifts claimed' do
      let!(:need_2) { FactoryBot.create(:need_with_shifts, office: need.office ) }

      it 'returns an integer which is the difference between shift created and shifts claimed' do
        result = dashboard_query.shifts_unclaimed

        expect(result).to equal(2)
      end
    end
  end
end
