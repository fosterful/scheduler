# frozen_string_literal: true

module Admin
  module UsersHelper
    def filtered_attributes(page)
      return page.attributes if action_name == 'edit'

      page.attributes.select { |attr| attr.attribute.in? %i(email role offices) }
    end
  end
end
