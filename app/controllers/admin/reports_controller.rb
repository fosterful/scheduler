# frozen_string_literal: true

require 'csv'

module Admin
  class ReportsController < Admin::ApplicationController
    def index; end

    def total_volunteer_minutes_by_office
      @headers = ['Office ID', 'Volunteer Minutes']
      @data = Office.total_volunteer_minutes_by_office
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-volunteer-minutes-by-office')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_volunteer_minutes_by_state
      @headers = ['State', 'Volunteer Minutes']
      @data = Office.total_volunteer_minutes_by_state
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-volunteer-minutes-by-state')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_volunteer_minutes_by_county
      @headers = ['County', 'Volunteer Minutes']
      @data = Office.total_volunteer_minutes_by_county(params['state'])
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-volunteer-minutes-by-county')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_children_served_by_office
      @headers = ['Office ID', 'Children Served']
      @data = Office.total_children_served_by_office
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-children-served-by-office')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_children_served_by_state
      @headers = ['State', 'Children Served']
      @data = Office.total_children_served_by_state
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-children-served-by-state')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_children_served_by_county
      @headers = ['County', 'Children Served']
      @data = Office.total_children_served_by_county(params['state'])
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-children-served-by-county')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_children_by_demographic
      @headers = ['Preferred Language', 'Number of Children']
      @data = Office.total_children_by_demographic
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-children-by-demographic')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_volunteers_by_race
      @headers = ['Race', 'Number of Volunteers']
      @data = Office.total_volunteers_by_race
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-volunteers-by-race')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_volunteer_minutes_by_user
      @headers = ['User ID', 'Total Volunteer Minutes']
      @data = User.total_volunteer_minutes_by_user
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-volunteer-minutes-by-user')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    def total_volunteers_by_spoken_language
      @headers = ['Language', 'Total Volunteer Minutes']
      @data = User.total_volunteers_by_spoken_language
      respond_to do |format|
        format.csv do
          headers['Content-Disposition'] = content_disposition('total-volunteers-by-spoken-language')
          headers['Content-Type'] = 'text/csv'
        end
        format.json { render json: @data.to_json }
      end
    end

    private

    def content_disposition(report_name)
      "attachment; filename=\"#{DateTime.current.to_i}-#{report_name}.csv\""
    end

    def find_resource(_param); end
  end
end
