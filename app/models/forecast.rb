class Forecast
  attr_reader :params

  def initialize(phase, params)
    @phase = phase
    @params = params
  end

  def forecast(sprint_start)
    worker_hours = @params[:week_hours].to_i
    sprint_size = @params[:sprint_size].blank? ? 7 : @params[:sprint_size].to_i

    items_by_week = ActiveSupport::OrderedHash.new
    current_week = sprint_start
    current_week_hours = 0

    items = @phase.stories(params)
    items.each do |i|
      week = items_by_week[current_week]
      if week.nil?
        items_by_week[current_week] = [i]
        current_week_hours += i.size
      else
        size = i.size
        if (size + current_week_hours) > worker_hours
          puts "- Over: #{current_week}, moving to next week"
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
