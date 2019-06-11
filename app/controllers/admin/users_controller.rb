# frozen_string_literal: true

module Admin
  class UsersController < Admin::ApplicationController

    # Redefining Admin::ApplicationController#index in order
    # to correctly sort users when order is 'name'
    def index
      search_term = params[:search].to_s.strip
      resources = Administrate::Search.new(scoped_resource,
                                           dashboard_class,
                                           search_term).run
      resources = apply_resource_includes(resources)

      # This is the unique part
      resources = begin
        if order.ordered_by?('name')
          resources.order("first_name || ' ' || last_name #{order.direction}")
        else
          order.apply(resources)
        end
      end
      # end unique part

      resources = resources.page(params[:page]).per(records_per_page)
      page = Administrate::Page::Collection.new(dashboard, order: order)

      render locals: {
        resources: resources,
        search_term: search_term,
        page: page,
        show_search_bar: show_search_bar?,
      }
    end

    def create
      resource = invite_resource
      if resource.errors.empty?
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

    private

    def invite_resource(&block)
      resource_class.invite!(invite_params, current_inviter, &block)
    end

    alias invite_params resource_params
    alias current_inviter current_user
  end
end
