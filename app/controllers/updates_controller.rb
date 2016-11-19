class UpdatesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    gem_name = params[:gem_name]
    loader = GemLoader.new
    if LaserGem.find_by(name: gem_name)
      redirect_to laser_gem_path(gem_name), notice: "You have sucessfully requested an update for this gem"
      UpdateLaserGemJob.perform_later(gem_name)
    elsif loader.get_spec_from_api(gem_name) == nil
      redirect_to updates_show_path, notice: "This does not appear to be a valid gem. Please make sure this gem has been uploaded to rubygems.org"
    else
      redirect_to laser_gem_path(gem_name), notice: "You have sucessfully requested an update for this gem"
      UpdateLaserGemJob.perform_later(gem_name)
    end
  end
end
