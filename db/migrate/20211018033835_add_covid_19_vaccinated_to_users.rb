class AddCovid19VaccinatedToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :covid_19_vaccinated, :boolean
  end
end
