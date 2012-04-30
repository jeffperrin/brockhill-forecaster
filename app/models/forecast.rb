class Forecast
  attr_reader :params

  def initialize(stories, params)
    @stories = stories
    @params = params
  end

  def forecast(sprint_start)
    worker_hours = @params[:week_hours].blank? ? 128 : @params[:week_hours].to_i
    sprint_size = @params[:sprint_size].blank? ? 14 : @params[:sprint_size].to_i

    items_by_week = ActiveSupport::OrderedHash.new
    current_week = sprint_start
    current_week_hours = 0

    items = @stories
    items.each do |i|
      week = items_by_week[current_week]
      if week.nil?
        items_by_week[current_week] = [i]
        current_week_hours += i.size
      else
        size = i.size
        if (size + current_week_hours) > worker_hours
          current_week_hours = size
          current_week = current_week + sprint_size
          items_by_week[current_week] = [i]
        else
          current_week_hours += size
          items_by_week[current_week] << i
        end
      end
    end

    items_by_week
  end
end
