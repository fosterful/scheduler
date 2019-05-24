# frozen_string_literal: true

require 'csv'

module Admin
  class ReportsController < Admin::ApplicationController
    def index; end

    def total_volunteer_minutes_by_office
      respond_to do |format|
        format.html { send_data generate_csv(%w(office_id volunteer_minutes), Office.total_volunteer_minutes_by_office), filename: "#{DateTime.current.to_i}-total-volunteer-minutes-by-office.csv" }
        format.json { render json: Office.total_volunteer_minutes_by_office.to_json }
      end
    end

    def total_volunteer_minutes_by_state
      respond_to do |format|
        format.html { send_data generate_csv(%w(state volunteer_minutes), Office.total_volunteer_minutes_by_state), filename: "#{DateTime.current.to_i}-total-volunteer-minutes-by-state.csv" }
        format.json { render json: Office.total_volunteer_minutes_by_state.to_json }
      end
    end

    def total_volunteer_minutes_by_county
      respond_to do |format|
        format.html { send_data generate_csv(%w(county volunteer_minutes), Office.total_volunteer_minutes_by_county(params['state'])), filename: "#{DateTime.current.to_i}-total-volunteer-minutes-by-county.csv" }
        format.json { render json: Office.total_volunteer_minutes_by_county(params['state']).to_json }
      end
    end

    def total_children_served_by_office
      respond_to do |format|
        format.html { send_data generate_csv(%w(office_id children_served), Office.total_children_served_by_office), filename: "#{DateTime.current.to_i}-total-children-served-by-office.csv" }
        format.json { render json: Office.total_children_served_by_office.to_json }
      end
    end

    def total_children_served_by_state
      respond_to do |format|
        format.html { send_data generate_csv(%w(state children_served), Office.total_children_served_by_state), filename: "#{DateTime.current.to_i}-total-children-served-by-state.csv" }
        format.json { render json: Office.total_children_served_by_state.to_json }
      end
    end

    def total_children_served_by_county
      respond_to do |format|
        format.html { send_data generate_csv(%w(county children_served), Office.total_children_served_by_county(params['state'])), filename: "#{DateTime.current.to_i}-total-children-served-by-county.csv" }
        format.json { render json: Office.total_children_served_by_county(params['state']).to_json }
      end
    end

    def total_children_by_demographic
      respond_to do |format|
        format.html { send_data generate_csv(%w(preferred_language number_of_children), Office.total_children_by_demographic), filename: "#{DateTime.current.to_i}-total-children-by-demographic.csv" }
        format.json { render json: Office.total_children_by_demographic.to_json }
      end
    end

    def total_volunteers_by_race
      respond_to do |format|
        format.html { send_data generate_csv(%w(race number_of_volunteers), Office.total_volunteers_by_race), filename: "#{DateTime.current.to_i}-total-volunteers-by-race.csv" }
        format.json { render json: Office.total_volunteers_by_race.to_json }
      end
    end

    def total_volunteer_minutes_by_user
      respond_to do |format|
        format.html { send_data generate_csv(%w(user_id total_volunteer_minutes), User.total_volunteer_minutes_by_user), filename: "#{DateTime.current.to_i}-total-volunteer-minutes-by-user.csv" }
        format.json { render json: User.total_volunteer_minutes_by_user.to_json }
      end
    end

    def total_volunteers_by_spoken_language
      respond_to do |format|
        format.html { send_data generate_csv(%w(language total_volunteer_minutes), User.total_volunteers_by_spoken_language), filename: "#{DateTime.current.to_i}-total-volunteers-by-spoken-language.csv" }
        format.json { render json: User.total_volunteers_by_spoken_language.to_json }
      end
    end

    private

    def generate_csv(column_labels, data)
      CSV.generate(headers: true) do |csv|
        csv << column_labels
        data.each do |k, v|
          csv << [k, v]
        end
      end
    end

    def find_resource(_param); end
  end
end
