class InvitationsController < Devise::InvitationsController
  rescue_from(ActionController::ParameterMissing) do |parameter_missing_exception|
    redirect_to root_path, flash: { error: "Required parameter missing: #{parameter_missing_exception.param}" }
  end
  
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
