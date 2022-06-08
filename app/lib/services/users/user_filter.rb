# frozen_string_literal: true
module Services
  module Users
    class IndexFilter < Services::Generic::IndexFilter
      FILTERS = {
        size_filter: {
          apply?: ->(params) {
            params[:size].is_a?(String)
          },
          apply: ->(scope, params) {
            scope.where(size: params[:size])
          }
        }.freeze,
        name_contains_filter: {
          apply?: ->(params) {
            params[:name_contains].is_a?(String)
          },
          apply: ->(scope, params) {
            scope.where('name ILIKE ?', "%#{params[:name_contains]}%")
          }
        }.freeze
      }.freeze

      def self.filters
        FILTERS
      end
    end
  end
end
