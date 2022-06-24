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

  describe '#active_by_hours' do
    # I want to create multiple needs, with different users but same office
    let()
    # can I do need_2.office = :office_id?, this should overwrite office generated?

    it 'returns a sorted array of hashes, of active record relations, in decending order of hours volunteered' do
      result = dashboard_query.active_by_hours

      expect().to equal()
    end

    # Additional test for
    #four things, pulling data from DB, summing data, formating pulled data, sorting data.
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
    context 'finds the proper office id' do
      let!(:need_2) { FactoryBot.create(:need_with_assigned_shifts) }

      it 'returns an integer which represents all shift created within the timeframe passed in' do
        result = dashboard_query.shifts_created

        expect(result).to equal(2)
      end
    end

    # Implied on line 49. Do we need to test this here? Meaning this really should be a property of DateRangeFilterHelper or possible form controller.
    xcontext 'when start date is before end date' do
      it 'returns an integer which represents all shifts created within the timeframe passed in' do
        result = dashboard_query.shifts_created

        expect(result).to equal(2)
      end
    end

    # Do we need to test this here? Meaning this really should be a property of DateRangeFilterHelper.
    # Need a method to handle error
    xcontext 'when start_date is after end_date' do
      let(:need_created_at_start_date) {
        need.created_at.end_of_month.to_date.to_s
      }
      let(:need_created_at_end_date) {
        need.created_at.beginning_of_month.to_date.to_s
      }

      it 'returns an error message' do
        result = dashboard_query.shifts_created

        #verification
      end
    end
  end

  describe '#shifts_unclaimed' do
    it 'returns an integer which is the difference between shift created and shifts claimed' do
      result = dashboard_query.shifts_unclaimed

      expect(result).to equal(0)
    end

    # Implied in line 87 that shift_created >= shift claimed, but also no direct way to test this because it depends on values in DB
    # I really want to know that this value >= 0
    xcontext 'when shift created is greater than shifts claimed' do
      it 'returns an integer which is the difference between shift created and shifts claimed' do
        result = dashboard_query.shifts_unclaimed

        expect(result).to equal(0)
      end
    end

    # I really want to know that this value >= 0
    xcontext 'when shift created is less than shifts claimed' do
      it 'returns an error message' do
        result = dashboard_query.shifts_unclaimed

        # error message
      end
    end
  end
end
