class RegistrationsController < Devise::RegistrationsController
  def vaccination_status
    if user_signed_in?
      render :vaccination_status
    else
      redirect_to root_path
    end
  end

  protected

  def update_resource(resource, params)
    if params.keys == ['covid_19_vaccinated']
      resource.update_without_password(params)
    else
      super
    end
  end

end