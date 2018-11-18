module Admin
  class UsersController < Admin::ApplicationController
    def create
      resource = invite_resource
      if resource.errors.empty?
        redirect_to(
          [namespace, resource],
          notice: translate_with_resource("create.success"),
          )
        else
        render :new, locals: {
          page: Administrate::Page::Form.new(dashboard, resource),
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
