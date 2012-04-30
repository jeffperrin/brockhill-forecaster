require 'httparty'
require 'active_model'

class Project
  include HTTParty
  include ActiveModel::Conversion
  include ActiveModel::Validations

  base_uri "https://agilezen.com/api/v1"

  attr_accessor :api_key, :id, :name, :description

  validates :api_key, :presence => true
  validates :id, :presence => true

  def initialize(attributes={})
    return if attributes.nil?

    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def self.all(api_key)
    projects = get("https://agilezen.com/api/v1/projects?apikey=#{api_key}")['items']
    projects.map do |item|
      Project.new(api_key: api_key, id: item['id'], name: item['name'], description: item['description'])
    end
  end

  def stories(params={})
    items = self.class.get("/projects/#{id}/stories.json?apikey=#{api_key}&where=phase:backlog")['items']
    items.first.class.send :define_method, :story_type do
      return "Story" if self['color'] == 'yellow'
      return "Bug" if self['color'] == 'green'
      return "Technical Story" if self['color'] == 'purple'
      return "Unknown"
    end

    items.first.class.send :define_method, :size do
      story_size = params[:story_size].blank? ? 16 : params[:story_size].to_i
      bug_size =params[:bug_size].blank? ? 4 : params[:bug_size].to_i

      if self['size'].blank?
        self.story_type =~ /Story/ ? story_size : bug_size
      else
        self['size'].to_i
      end
    end

    items
  end

  def forecast(sprint_start, options={})
    forecaster = Forecast.new(stories(options), options)
    forecaster.forecast(sprint_start)
  end
end
