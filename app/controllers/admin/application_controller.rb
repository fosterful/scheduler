# frozen_string_literal: true

# All Administrate controllers inherit from this `Admin::ApplicationController`,
# making it the ideal place to put authentication logic or other
# before_actions.
#
# If you want to add pagination or other controller-level concerns,
# you're free to overwrite the RESTful controller actions.
module Admin
  class ApplicationController < Administrate::ApplicationController
    include Administrate::Punditize

    before_action :authenticate_admin

    def authenticate_admin
      return if current_user&.role == 'admin'

      redirect_to root_path, flash: { error: 'Not authorized.' }
    end

    # Uses Pundit helper
    def resource_params
      permitted_attributes(resource_class)
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end
end
