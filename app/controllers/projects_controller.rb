class ProjectsController < ApplicationController
  def index
    @projects = Project.all(params[:project][:api_key])
  end
end