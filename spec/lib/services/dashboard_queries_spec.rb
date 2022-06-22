# frozen_string_literal: true

require 'rails_helper'

Rspec.describe Services::DashboardQueries do
  #subject { described_class.(need) }

  # instatiating start_time for testing
  let(:need_start_at) { Time.zone.parse('2019-01-09 08:00:00 -0800') }
  let(:need) { build :need, start_at: need_start_at }

  # what info do we need to test?
   office, ie two # do we need test if we have more than one office?
   users ie one of each role type (does it matter?>)
   needs
   shifts


  # where do we use factorybot? when do we use build ie like create but doesnt save. We have a factory

  context "multiple shift hours belonging to few needs and at least two office?" do

    describe '#active_by_hours' do
      it "returns an active relation table?" do
        expect active_by_hours. to match/include(some value)
      end
    end

    describe '#active_by_hours' do
      it "returns an array of hashes for each user" do
        expect active_by_hours. to match/include(some value)
      end
    end

    describe '#active_by_hours' do
      it "returns a sorted array" do
        expect active_by_hours. to match/include(some value)
        # I was told in a workshop I should create a file with a sorted list and import the file to use it as my comparison. ie to match(file)
      end
    end
  end

end

context "multiple shift belonging, few needs and at least two office?" do

  describe '#active_by_needs' do
    it "returns the sum of needs created by each user" do
      expect active_by_hours. to match/include(some value)
    end
  end
