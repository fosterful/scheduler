RSpec.describe ApplicationPolicy, type: :policy do
  let(:user)   { build(:user) }
  let(:record) { build(:user) }

  subject { described_class.new(user, record) }

  it { expect(subject).to forbid_action(:index) }
  it { expect(subject).to forbid_action(:show) }
  it { expect(subject).to forbid_action(:new) }
  it { expect(subject).to forbid_action(:create) }
  it { expect(subject).to forbid_action(:edit) }
  it { expect(subject).to forbid_action(:update) }
  it { expect(subject).to forbid_action(:destroy) }
  
  describe ApplicationPolicy::Scope do
    subject { described_class.new(user, scope) }

    let(:user) { :user }
    let(:scope) { double.as_null_object }

    it 'returns scope' do
      expect(subject.scope).to eq(scope)
    end

    it 'returns user' do
      expect(subject.user).to eq(user)
    end

    it 'returns @solve when #resolve is called' do
      expect(subject.resolve).to eq(scope)
    end
  end
end