class HomeController < ApplicationController
  def show
    @project = Project.new
  end
end