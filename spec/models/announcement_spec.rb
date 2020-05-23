require 'rails_helper'

RSpec.describe Announcement, type: :model do
  let(:announcement) { build :announcement }

  it 'has a valid factory' do
    expect(announcement.valid?).to be(true)
  end

  describe '#send_messages' do
    let(:phone_numbers) { ['(360) 610-7089'] }

    it 'send_messages' do
      expect(Services::TextMessageEnqueue)
        .to receive(:send_messages)
              .with(phone_numbers, 'MyText')
              .and_call_original

      announcement.send_messages
    end
  end

end
