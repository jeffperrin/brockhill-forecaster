class ProjectsController < ApplicationController
  def index
    api_key = params[:project][:api_key]
    if api_key.blank?
      flash[:notice] = 'Please enter your AgileZen API key'
      redirect_to root_path
    else
      @projects = Project.all(api_key)
    end
  end
end
