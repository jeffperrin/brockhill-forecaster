require 'httparty'
require 'active_model'

class Project
  include HTTParty
  include ActiveModel::Conversion
  include ActiveModel::Validations

  base_uri "https://agilezen.com/api/v1"

  attr_accessor :api_key, :project_id, :phase_id

  validates :api_key, :presence => true
  validates :project_id, :presence => true

  def initialize(attributes={})
    return if attributes.nil?

    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def stories(params={})
    items = self.class.get("/projects/#{@project_id}/stories.json?apikey=#{@api_key}&where=phase:backlog")['items']

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
    ap "forecasting"
    forecaster = Forecast.new(stories(options), options)
    forecaster.forecast(sprint_start)
  end
end
