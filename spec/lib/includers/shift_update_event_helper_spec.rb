# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ShiftUpdateEventHelper do
  let(:object) do
    Class.new do
      include described_class
    end
  end

  # TODO: auto-generated
  describe '#shift_user_is_current_user?' do
    it 'shift_user_is_current_user?' do
      result = object.shift_user_is_current_user?

      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#current_user_left_shift?' do
    it 'current_user_left_shift?' do
      result = object.current_user_left_shift?

      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#scheduler_with_user?' do
    it 'scheduler_with_user?' do
      result = object.scheduler_with_user?

      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#scheduler_without_user?' do
    it 'scheduler_without_user?' do
      result = object.scheduler_without_user?

      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#social_workers_and_need_user' do
    it 'social_workers_and_need_user' do
      result = object.social_workers_and_need_user

      expect(result).not_to be_nil
    end
  end

  # TODO: auto-generated
  describe '#social_workers' do
    it 'social_workers' do
      result = object.social_workers

      expect(result).not_to be_nil
    end
  end

end
