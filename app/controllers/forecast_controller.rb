require 'csv'

class ForecastController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    if params[:week_hours].blank?
      @items_by_week = {}
    else
      raise 'API key is required' if params[:api_key].blank?
      raise 'Project id is required' if params[:project_id].blank?
      raise 'Phase id is required' if params[:phase_id].blank?
      
      phase = Phase.new(params[:api_key], params[:project_id], params[:phase_id])
      forecaster = Forecast.new(phase, params)
      @items_by_week = forecaster.forecast(Date.today.next_week)
    end

    respond_to do |format|
      format.html do
      end

      format.csv do
        csv_string = CSV.generate do |csv|
          csv << ['Iteration start', 'AgileZen ID', 'Size', 'Type', 'Description']
          @items_by_week.each do |week, items|
            csv << [week.to_s(:short)]
            items.each do |i|
              csv << ['', i['id'], i.size, i.story_type, truncate(i['text'], :length => 90) ]
            end
          end

        end

        filename = Time.now.strftime("%F:%T_backlog") + ".csv"
        send_data(csv_string, :type => 'text/csv; charset=utf-8; header=present', :filename => filename)
      end
    end
  end
end
