class LaserGemsController < ApplicationController

  # GET /laser_gems
  def index
    @laser_gems = LaserGem.all
  end

  # GET /laser_gems/gem_name
  def show
    @laser_gem = LaserGem.find_by_name(params[:name])
  end

  def add_tag
    @laser_gem = LaserGem.find_by_name(params[:name])
    if tag_is_valid
      @laser_gem.tag_list.add(params[:tag])
      @laser_gem.save
      redirect_to laser_gem_path(@laser_gem.name)
    else
      flash[:notice] = "Please insert a valid tag."
      render :show  
    end
  end

  private

  def tag_is_valid
    if params[:tag].include?(" ")
      false
    else
      true
    end
  end
end
