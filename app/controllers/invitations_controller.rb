class InvitationsController < Devise::InvitationsController
  def new
    self.resource = resource_class.new(permitted_attributes(User.new))
    authorize resource
    render :new
  end

  def create
    resource = resource_class.new(invite_params)
    authorize resource
    super
  end
end
