# frozen_string_literal: true

module Services
  class SendShiftStatusNotifications
    include Procto.call
    include Concord.new(:shift)
    include Adamantium::Flat

    delegate :need, :duration, :user
             to: :shift

    def call
      Rails.logger.info("Shift status changed")
    end
  end
end
