require 'httparty'
require 'active_model'

class Project
  include HTTParty
  include ActiveModel::Conversion
  include ActiveModel::Validations

  base_uri "https://agilezen.com/api/v1"

  attr_accessor :api_key, :id, :name, :description, :forecast_options

  validates :api_key, :presence => true
  validates :id, :presence => true

  def initialize(attributes={})
    return if attributes.nil?
    self.forecast_options = ForecastOptions.new
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def forecast_options_attributes=(attributes)
    self.forecast_options = ForecastOptions.new(attributes)
  end

  def self.all(api_key)
    projects = get("https://agilezen.com/api/v1/projects?apikey=#{api_key}")['items']
    projects.map do |item|
      Project.new(api_key: api_key, id: item['id'], name: item['name'], description: item['description'])
    end
  end

  def stories(params={})
    forecast_options = self.forecast_options

    backlog_id = self.class.get("/projects/#{id}/phases.json?apikey=#{api_key}")['items'][0]['id']
    items = self.class.get("/projects/#{id}/phases/#{backlog_id}/stories.json?apikey=#{api_key}", {})['items']

    items.first.class.send :define_method, :story_type do
      return "Story" if self['color'] == 'yellow'
      return "Bug" if self['color'] == 'green'
      return "Technical Story" if self['color'] == 'purple'
      return "Unknown"
    end

    items.first.class.send :define_method, :size do
      story_size = forecast_options.story_size
      bug_size = forecast_options.bug_size

      if self['size'].blank?
        self.story_type =~ /Story/ ? story_size : bug_size
      else
        self['size'].to_i
      end
    end

    items
  end

  def forecast()
    forecaster = Forecast.new(stories, forecast_options)
    forecaster.forecast
  end
end
