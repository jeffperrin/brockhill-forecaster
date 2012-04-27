class Phase
  require 'httparty'
  include HTTParty

  base_uri "https://agilezen.com/api/v1"

  def initialize(api_key, project_id, phase_id)
    @api_key = api_key
    @project_id = project_id
    @phase_id = phase_id
  end

  def stories(params={})
    items = self.class.get("/projects/#{@project_id}/phases/#{@phase_id}/stories.json?apikey=#{@api_key}")['items']

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
end
