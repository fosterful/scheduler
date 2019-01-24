# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::BulkInserter::Insert do
  subject { described_class.call(records) }
  let(:now) { Time.zone.now }
  let(:user) { create :user }

  context 'valid records' do
    let(:records) { build_list(:blockout, 3, user: user ) }

    it 'inserts records' do
      expect { subject }.to change(Blockout, :count).by(3)
    end

    context 'created_at & updated_at present' do
      let(:records) { build_list(:blockout, 3, user: user, created_at: 1.day.ago, updated_at: 1.day.ago ) }

      it 'uses the values passed' do
        expect { subject }.to change { Blockout.where('created_at < ?', Time.zone.now.beginning_of_day).count }.by(3)
      end
    end
  end

  context 'invalid records' do
    let(:records) { build_list(:blockout, 3, user: user, start_at: nil ) }

    it 'raises an error' do
      expect { subject }.to raise_error(Services::BulkInserter::Error, 'Some records were invalid!')
    end
  end

  context 'records with mixed attributes present' do
    let(:records) { [ build(:blockout), build(:blockout, parent_id: 123)] }

    it 'raises an error' do
      expect { subject }.to raise_error(Services::BulkInserter::Error, 'All records must have the same attributes present')
    end
  end

  context 'records with mixed table names' do
    let(:records) { [ build(:blockout), build(:user)] }

    it 'raises an error' do
      expect { subject }.to raise_error(Services::BulkInserter::Error, 'All records must have the same table name')
    end
  end
end
