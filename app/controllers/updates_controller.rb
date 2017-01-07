require "git_loader"
require "gem_loader"

class UpdatesController < ApplicationController

  impressionist

  def show
  end

  def bounce
    @gem_name = params[:gem_name]
    count = params[:count].to_i
    if LaserGem.find_by(name: @gem_name)
      redirect_to laser_gem_path(@gem_name)
    else
      if( count > 2 )
        redirect_to laser_gems_path
      else
        redirect_to updates_bounce_path(@gem_name , count: count + 1)
      end
    end
  end

  def update
    gem_name = params[:gem_name]
    loader = GemLoader.new
    if LaserGem.find_by(name: gem_name)
      UpdateLaserGemJob.set.perform_later(gem_name)
      redirect_to updates_bounce_path(gem_name)
    elsif loader.get_spec_from_api(gem_name) == nil
      redirect_to updates_show_path, notice: "This does not appear to be a valid gem. Please make sure this gem has been uploaded to rubygems.org"
    else
      UpdateLaserGemJob.set.perform_later(gem_name)
      redirect_to updates_bounce_path(gem_name)
    end
  end
end
