require 'csv'

class ForecastController < ApplicationController
  include ActionView::Helpers::TextHelper

  def index
    @project = Project.new(params[:project])

    if @project.valid?
      @items_by_week = @project.forecast(Date.today.next_week, params)
      respond_to do |format|
        format.html
        format.csv do
          csv_string = CSV.generate do |csv|
            csv << ['Iteration start', 'AgileZen ID', 'Size', 'Type', 'Description']
            @items_by_week.each do |week, items|
              csv << [week.to_s(:short)]
              items.each do |i|
                csv << ['', i['id'], i.size, i.story_type, truncate(i['text'], length: 90) ]
              end
            end
          end

          filename = Time.now.strftime("%F:%T_backlog") + ".csv"
          send_data(csv_string, type: 'text/csv; charset=utf-8; header=present', filename: filename)
        end
      end
    else
      render :index      
    end
  end
end
