# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShiftUpdateEventHelper do

  let(:shift) { create(:shift) }
  let(:need) { shift.need }
  let(:current_user) { volunteer }
  let(:object) do
    instance_double(
      Services::Notifications::Shifts::Recipients::Update,
      current_user: current_user,
      user_was:     nil,
      need:         need,
      user:         shift.user
    ).extend(described_class)
  end
  let(:volunteer)       { create(:user, offices: [shift.office], role: User::VOLUNTEER) }
  let(:social_worker)   { create(:user, offices: [shift.office], role: User::SOCIAL_WORKER) }
  let(:coordinator)     { create(:user, offices: [shift.office], role: User::COORDINATOR) }
  let(:admin)           { create(:user, offices: [shift.office], role: User::ADMIN) }
  let(:non_notifiable)  { create(:user, offices: [shift.office], role: User::SOCIAL_WORKER) }

  before do
    [volunteer, social_worker, coordinator, admin].each do |user|
      office_user = OfficeUser.where(user: user, office: shift.office).first
      office_user.update!(send_notifications: true)
    end
  end

  describe '#shift_user_is_current_user?' do
    it 'returns false when shift does not have a user' do
      result = object.shift_user_is_current_user?

      expect(result).to be false
    end

    it 'returns true when shift user is current user' do
      shift.user = volunteer
      shift.save!

      result = object.shift_user_is_current_user?

      expect(result).to be true
    end

    it 'returns false when current user is not shift user' do
      allow(object).to receive(:current_user).and_return(social_worker)

      result = object.shift_user_is_current_user?

      expect(result).to be false
    end
  end

  describe '#current_user_left_shift?' do
    it 'returns false if current_user is assigned to shift' do
      result = object.current_user_left_shift?

      expect(result).to be false
    end

    it 'returns false if user assigned to shift, but user_was is nil' do
      allow(object).to receive(:user_was).and_return(nil)

      result = object.current_user_left_shift?

      expect(result).to be false
    end

    it 'returns false if user_was is not current_user' do
      allow(object).to receive(:user_was).and_return(social_worker)

      result = object.current_user_left_shift?

      expect(result).to be false
    end

    it 'returns false if user_was is nil and no user assigned to shift' do
      allow(object).to receive(:user).and_return(nil)

      result = object.current_user_left_shift?

      expect(result).to be false
    end

    it 'returns true if user nil, and current_user is user_was' do
      allow(object).to receive(:user).and_return(nil)
      allow(object).to receive(:user_was).and_return(volunteer)

      result = object.current_user_left_shift?

      expect(result).to be true
    end

    it 'returns true if user present and current_user is user_was' do
      allow(object).to receive(:user_was).and_return(volunteer)

      result = object.current_user_left_shift?

      expect(result).to be true
    end
  end

  describe '#scheduler_with_user?' do
    context 'when current user is not a scheduler' do
      it 'returns false if shift not assigned' do
        allow(object).to receive(:user).and_return(nil)

        result = object.scheduler_with_user?

        expect(result).to be false
      end

      it 'returns false if shift assigned' do
        shift.user = coordinator
        shift.save!

        result = object.scheduler_with_user?

        expect(result).to be false
      end
    end

    context 'when current_user is a scheduler' do
      let(:current_user) { coordinator }

      it 'returns false if shift not assigned' do
        allow(object).to receive(:user).and_return(nil)

        result = object.scheduler_with_user?

        expect(result).to be false
      end

      it 'returns true if shift assigned' do
        shift.user = coordinator
        shift.save!

        result = object.scheduler_with_user?

        expect(result).to be true
      end
    end
  end

  describe '#scheduler_without_user?' do
    context 'when current user is not a scheduler' do
      it 'returns false if shift not assigned' do
        allow(object).to receive(:user).and_return(nil)

        result = object.scheduler_without_user?

        expect(result).to be false
      end

      it 'returns false if shift assigned' do
        shift.user = coordinator
        shift.save!

        result = object.scheduler_without_user?

        expect(result).to be false
      end
    end

    context 'when current_user is a scheduler' do
      let(:current_user) { coordinator }

      it 'returns true if shift not assigned' do
        allow(object).to receive(:user).and_return(nil)

        result = object.scheduler_without_user?

        expect(result).to be true
      end

      it 'returns false if shift assigned' do
        shift.user = social_worker
        shift.save!

        result = object.scheduler_without_user?

        expect(result).to be false
      end
    end
  end

  describe '#notifiable_office_users_and_need_user' do
    it 'returns need user and all notifiable office users associated with the office' do
      result = object.notifiable_office_users_and_need_user

      expect(result).to match_array([social_worker, coordinator, admin, need.user])
    end
  end

  describe '#notifiable_office_users' do
    it 'returns all notifiable office users associated with the office' do
      result = object.notifiable_office_users

      expect(result).to match_array([social_worker, coordinator, admin])
    end
  end
end
