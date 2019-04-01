# frozen_string_literal: true

module Admin
  class OfficesController < Admin::ApplicationController
    def create
      # Gets geocode skip confirmation checkbox
      skip_conf = params.dig('office', 'skip_confirmation') == '1'
      resource = resource_class.new(resource_params)
      authorize_resource(resource)
      # Acts on geocode skip confirmation checkbox
      resource.skip_confirmation! if skip_conf

      if resource.save
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource('create.success')
        )
      else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource)
        }
      end
    end
  end
end
