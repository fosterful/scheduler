credentials = Rails.application.credentials.smartystreets

if credentials.present?
  Geocoder.config[:smarty_streets] ||= {
    api_key: [
      credentials[:auth_id],
      credentials[:auth_token]
    ]
  }

  # This looks for auth_id as an env var
  # by default. We don't have one :-)
  module MainStreet
    class AddressVerifier
      def lookup
        :smarty_streets
      end
    end
  end
end