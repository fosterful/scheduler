# frozen_string_literal: true

module Admin
  module UsersHelper
    def filtered_attributes(page)
      return page.attributes if action_name.in?(%w(edit update))

      page.attributes.select do |attr|
        attr.attribute.in? %i(email role offices)
      end
    end
  end
end
