class ForecastOptions
  include ActiveModel::Conversion
  include ActiveModel::Validations

  Defaults = {sprint_hours: 128, sprint_size: 14, story_size: 16, bug_size: 4, sprint_start: Date.today.next_week}
  attr_accessor :sprint_hours, :sprint_size, :story_size, :bug_size, :sprint_start

  validates :sprint_hours,  numericality: { only_integer: true, greater_than: 0 }
  validates :sprint_size,   numericality: { only_integer: true, greater_than: 0 }
  validates :story_size,    numericality: { only_integer: true, greater_than: 0 }
  validates :bug_size,      numericality: { only_integer: true, greater_than: 0 }

  def initialize(attributes={})
    attributes = Defaults.merge(attributes || {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def sprint_hours
    @sprint_hours.to_i
  end

  def sprint_size
    @sprint_size.to_i
  end

  def story_size
    @story_size.to_i
  end

  def bug_size
    @bug_size.to_i
  end

  def persisted?
    false
  end
end
