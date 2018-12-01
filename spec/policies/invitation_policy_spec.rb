require 'rails_helper'

RSpec.describe InvitationPolicy, type: :policy do
  describe '#invite?' do
    context 'as an admin' do
      let(:user)   { build(:user, role: 'admin') }

      User::ROLES.each do |role|
        context "inviting a #{role}" do
          subject { described_class.new(user, build(:user, role: role)) }
          it { expect(subject).to permit_action(:invite) }
        end
      end
    end
  end

  context 'as a coordinator' do
    let(:user)   { build(:user, role: 'coordinator') }

    %w[volunteer social_worker].each do |role|
      context "inviting a #{role}" do
        subject { described_class.new(user, build(:user, role: role)) }
        it { expect(subject).to permit_action(:invite) }
      end
    end

    %w[admin coordinator].each do |role|
      context "inviting a #{role}" do
        subject { described_class.new(user, build(:user, role: role)) }
        it { expect(subject).to forbid_action(:invite) }
      end
    end
  end

  context 'as a social_worker' do
    let(:user)   { build(:user, role: 'social_worker') }

    context "inviting a volunteer" do
      subject { described_class.new(user, build(:user, role: 'volunteer')) }
      it { expect(subject).to permit_action(:invite) }
    end

    %w[coordinator social_worker admin].each do |role|
      context "inviting a #{role}" do
        subject { described_class.new(user, build(:user, role: role)) }
        it { expect(subject).to forbid_action(:invite) }
      end
    end
  end

  context 'as a volunteer' do
    let(:user)   { build(:user, role: 'volunteer') }

    User::ROLES.each do |role|
      context "inviting a #{role}" do
        subject { described_class.new(user, build(:user, role: role)) }
        it { expect(subject).to forbid_action(:invite) }
      end
    end
  end
end
