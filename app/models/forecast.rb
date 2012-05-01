class Forecast
  attr_reader :params

  def initialize(stories, forecast_options)
    @stories = stories
    @forecast_options = forecast_options
  end

  def forecast
    worker_hours = @forecast_options.sprint_hours
    sprint_size = @forecast_options.sprint_size

    items_by_week = ActiveSupport::OrderedHash.new
    current_week = @forecast_options.sprint_start
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
