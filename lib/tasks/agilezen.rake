require 'json'
require 'awesome_print'
require 'httparty'
require 'rest-client'

namespace :agilezen do
  desc "Exports cucumber stories to agilezen (will delete existing backlog items)"
  task :push, :api_key, :project_id do |t, args|
    zen = Zen.new(args[:api_key], args[:project_id])
    zen.delete_all_stories_from_backlog
    
    system("cucumber features_pending/ -f json -o pending_features.json")
    features = JSON.parse File.read("pending_features.json")

    features.each do |feature|
      puts "-------------"
      
      details = "Feature: #{feature['name']}\n"
      details += "#{feature["description"]}\n\n"
      total_estimate = 0
      
      feature['elements'].each do |scenario|
        estimate = scenario["tags"][0]["name"][1..-1] unless scenario["tags"].blank?
        estimate = estimate.blank? ? 4 : estimate.to_i
        total_estimate += estimate
        details += "  Scenario: #{scenario["name"]} (estimate: #{estimate})\n"
      end
      puts details
      zen.add_story({"text" => "#{feature['name']}", "details" => "<pre>#{details}</pre>", "color" => "yellow", "size" => "#{total_estimate}"})
    end
    system("rm pending_features.json")
  end
end

class Zen
  include HTTParty
  base_uri "https://agilezen.com/api/v1"

  def initialize(api_key, project_id)
    @api_key = api_key
    @project_id = project_id
  end

  def delete_all_stories_from_backlog()
    self.class.delete("/projects/#{@project_id}/stories.json?apikey=#{@api_key}&where=phase:backlog")
  end

  def add_story(story)
    payload = story.to_json
    response = RestClient.post "https://agilezen.com/api/v1/projects/#{@project_id}/stories",
      payload,
      {'Content-Type' =>'application/json', 'Accept' => 'application/json', 'X-Zen-ApiKey' => @api_key}
  end
end
