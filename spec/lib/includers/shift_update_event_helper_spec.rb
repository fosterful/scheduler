# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShiftUpdateEventHelper do

  let(:shift) { create(:shift) }
  let(:need) { shift.need }
  let(:volunteer1) { create(:user, offices: [shift.office]) }
  let(:volunteer2) { create(:user, offices: [shift.office]) }
  let(:object) do
    double(Shift,
           current_user: volunteer1,
           user_was:     nil,
           need:         need,
           user:         shift.user).extend(described_class)
  end
  let(:social_worker1) do
    volunteer1.tap { |v| v.update!(role: User::SOCIAL_WORKER) }
  end
  let(:social_worker2) do
    volunteer2.tap { |v| v.update!(role: User::SOCIAL_WORKER) }
  end

  describe '#shift_user_is_current_user?' do
    it 'returns false when shift does not have a user' do
      result = object.shift_user_is_current_user?

      expect(result).to be false
    end

    it 'returns true when shift user is current user' do
      shift.user = volunteer1
      shift.save!

      result = object.shift_user_is_current_user?

      expect(result).to be true
    end

    it 'returns false when current user is not shift user' do
      allow(object).to receive(:current_user).and_return(volunteer2)

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
      allow(object).to receive(:user_was).and_return(volunteer2)

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
      allow(object).to receive(:user_was).and_return(volunteer1)

      result = object.current_user_left_shift?

      expect(result).to be true
    end

    it 'returns true if user present and current_user is user_was' do
      allow(object).to receive(:user_was).and_return(volunteer1)

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
        shift.user = volunteer2
        shift.save!

        result = object.scheduler_with_user?

        expect(result).to be false
      end
    end

    context 'when current_user is a scheduler' do
      before do
        volunteer1.update!(role: User::COORDINATOR)
      end

      it 'returns false if shift not assigned' do
        allow(object).to receive(:user).and_return(nil)

        result = object.scheduler_with_user?

        expect(result).to be false
      end

      it 'returns true if shift assigned' do
        shift.user = volunteer2
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
        shift.user = volunteer2
        shift.save!

        result = object.scheduler_without_user?

        expect(result).to be false
      end
    end

    context 'when current_user is a scheduler' do
      before do
        volunteer1.update!(role: User::COORDINATOR)
      end

      it 'returns true if shift not assigned' do
        allow(object).to receive(:user).and_return(nil)

        result = object.scheduler_without_user?

        expect(result).to be true
      end

      it 'returns false if shift assigned' do
        shift.user = volunteer2
        shift.save!

        result = object.scheduler_without_user?

        expect(result).to be false
      end
    end
  end

  describe '#social_workers_and_need_user' do
    it 'returns need user and all social workers associated with the office' do
      volunteer1.update!(role: User::SOCIAL_WORKER)
      volunteer2.update!(role: User::SOCIAL_WORKER)

      result = object.social_workers_and_need_user

      expect(result).to match_array([volunteer1, volunteer2, need.user])
    end

    it 'returns need user if no social workers' do
      result = object.social_workers_and_need_user

      expect(result).to match_array([need.user])
    end
  end

  describe '#social_workers' do
    before do
      need.user.update!(role: User::VOLUNTEER)
    end

    it 'returns all social workers associated with the office' do
      social_worker1
      social_worker2

      result = object.social_workers

      expect(result).to match_array([social_worker1, social_worker2])
    end

    it 'returns empty collection if no social workers' do
      result = object.social_workers

      expect(result).to match_array([])
    end
  end

end
