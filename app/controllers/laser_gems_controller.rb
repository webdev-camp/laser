class LaserGemsController < ApplicationController

  # GET /laser_gems
  def index
    @laser_gems = LaserGem.all
  end

  # GET /laser_gems/1
  def show
    @laser_gem = LaserGem.find(params[:id])
  end

  private

end
