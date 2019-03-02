# frozen_string_literal: true

class InvitationsController < Devise::InvitationsController
  def new
    self.resource = resource_class.new
    authorize User
    render :new
  end

  def create
    resource = resource_class.new(invite_params)
    authorize resource
    super
  end
end
