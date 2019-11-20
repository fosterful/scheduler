require "rails_helper"

RSpec.describe "needs/show", type: :view do
  let(:need) { create(:need_with_shifts) }
  let(:user) { create(:user) }

  before {
    assign(:need, need)
    assign(:shifts, need.shifts.order(:start_at))

    without_partial_double_verification do
      allow(view).to receive(:policy) do |record|
        Pundit.policy(user, record)
      end
      allow(view).to receive(:current_user) { user }
    end
  }

  context 'when no users have been notified' do
    it 'does not show unavailability section' do
      render
      expect(rendered).not_to match /unavailable-container/
    end
  end

  context 'when users have been notified' do
    let(:user2) { create(:user) }
    before { need.update(notified_user_ids: [user2.id]) }

    it 'does not show unavailability section' do
      render
      expect(rendered).not_to match /unavailable-container/
    end

    context 'when current user has been notified' do
      before { need.update(notified_user_ids: [user.id]) }

      it 'shows unavailability button' do
        render
        expect(rendered).to match /I am not available for this request./
      end

      context 'when current user has accepted a shift' do
        before { need.shifts.first.update(user: user) }

        it 'does not show unavailability button' do
          render
          expect(rendered).to match /You have claimed a shift./
        end
      end

      context 'when current user has marked themselves unavailable' do
        before { need.update(unavailable_user_ids: [user.id]) }

        it 'shows user is unavailable' do
          render
          expect(rendered).to match(
            /You have marked yourself as unavailable for this request./
          )
        end
      end
    end
  end
end
