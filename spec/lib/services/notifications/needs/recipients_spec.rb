# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Services::Notifications::Needs::Recipients do
  let(:object) { described_class.new(need, action) }
  let(:need) { create(:need, start_at: starts) }
  let(:starts) { Time.zone.now.tomorrow.change(hour: 12, minute: 0) }

  context 'on create' do
    let(:action) { :create }
    let(:klass) { Services::Notifications::Needs::Recipients::Create }

    it 'correctly routes create event' do
      expect(klass).to receive(:new).and_return(spy(klass))

      object.recipients
    end
  end

  context 'on update' do
    let(:action) { :update }
    let(:klass) { Services::Notifications::Needs::Recipients::Update }

    it 'correctly routes update event' do
      expect(klass).to receive(:new).and_return(spy(klass))

      object.recipients
    end
  end

  context 'on destroy' do
    let(:action) { :destroy }
    let(:klass) { Services::Notifications::Needs::Recipients::Destroy }

    it 'correctly routes destroy event' do
      expect(klass).to receive(:new).and_return(spy(klass))

      object.recipients
    end
  end
end
