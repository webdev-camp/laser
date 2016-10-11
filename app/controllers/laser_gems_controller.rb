class LaserGemsController < ApplicationController

  # GET /laser_gems
  def index
    @laser_gems = LaserGem.all
  end

  # GET /laser_gems/gem_name
  def show
    @laser_gem = LaserGem.find_by_name(params[:name])
  end

  private

end
