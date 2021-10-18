class RegistrationsController < Devise::RegistrationsController
  protected

  def update_resource(resource, params)
    if params.keys == ['covid_19_vaccinated']
      resource.update_without_password(params)
    else
      super
    end
  end
end