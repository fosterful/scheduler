# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserPolicy, type: :policy do
  let(:subject) { described_class.new(user, other_user) }
  let(:user) { build(:user) }
  let(:other_user) { build(:user) }

  describe '#new?' do
    context 'as an admin' do
      let(:user) { build(:user, role: 'admin') }

      User::ROLES.each do |role|
        context "inviting a #{role}" do
          subject { described_class.new(user, build(:user, role: role)) }

          it { expect(subject).to permit_action(:new) }
        end
      end
    end
  end

  context 'as a coordinator' do
    let(:user) { build(:user, role: 'coordinator') }

    %w(volunteer social_worker).each do |role|
      context "inviting a #{role}" do
        subject { described_class.new(user, build(:user, role: role)) }

        it { expect(subject).to permit_action(:new) }
      end
    end

    %w(admin coordinator).each do |role|
      context "inviting a #{role}" do
        subject { described_class.new(user, build(:user, role: role)) }

        it { expect(subject).to forbid_action(:new) }
      end
    end
  end

  context 'as a social_worker' do
    let(:user) { build(:user, role: 'social_worker') }

    context 'inviting a volunteer' do
      subject { described_class.new(user, build(:user, role: 'volunteer')) }

      it { expect(subject).to permit_action(:new) }
    end

    %w(coordinator social_worker admin).each do |role|
      context "inviting a #{role}" do
        subject { described_class.new(user, build(:user, role: role)) }

        it { expect(subject).to forbid_action(:new) }
      end
    end
  end

  context 'as a volunteer' do
    let(:user) { build(:user, role: 'volunteer') }

    User::ROLES.each do |role|
      context "inviting a #{role}" do
        subject { described_class.new(user, build(:user, role: role)) }

        it { expect(subject).to forbid_action(:new) }
      end
    end
  end

  describe '#create?' do
    it 'create?' do
      result = subject.create?

      expect(result).to be false
    end
  end

  describe '#destroy?' do
    it 'destroy?' do
      result = subject.destroy?

      expect(result).to be false
    end
  end

  describe '#permitted_attributes_for_create' do
    it 'permitted_attributes_for_create' do
      result = subject.permitted_attributes_for_create

      expect(result).to match_array([:birth_date,
                                     :conviction,
                                     :conviction_desc,
                                     :discovered_omd_by,
                                     :email,
                                     :first_language_id,
                                     :first_name,
                                     :last_name,
                                     :medical_limitations,
                                     :medical_limitations_desc,
                                     :phone,
                                     :race_id,
                                     :resident_since,
                                     :role,
                                     :time_zone,
                                     { age_range_ids: [] },
                                     { office_ids: [] }])
    end
  end

  describe '#permitted_attributes' do
    it 'permitted_attributes' do
      result = subject.permitted_attributes

      expect(result).to match_array([:birth_date,
                                     :conviction,
                                     :conviction_desc,
                                     :discovered_omd_by,
                                     :email,
                                     :first_language_id,
                                     :first_name,
                                     :last_name,
                                     :medical_limitations,
                                     :medical_limitations_desc,
                                     :phone,
                                     :race_id,
                                     :resident_since,
                                     :time_zone,
                                     { age_range_ids: [] },
                                     { office_ids: [] }])
    end
  end

end
