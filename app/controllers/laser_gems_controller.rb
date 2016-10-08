class LaserGemsController < ApplicationController
  before_action :set_laser_gem, only: [:show, :edit, :update, :destroy]

  # GET /laser_gems
  # GET /laser_gems.json
  def index
    @laser_gems = LaserGem.all
  end

  # GET /laser_gems/1
  # GET /laser_gems/1.json
  def show
  end

  # GET /laser_gems/new
  def new
    @laser_gem = LaserGem.new
  end

  # GET /laser_gems/1/edit
  def edit
  end

  # POST /laser_gems
  # POST /laser_gems.json
  def create
    @laser_gem = LaserGem.new(laser_gem_params)

    respond_to do |format|
      if @laser_gem.save
        format.html { redirect_to @laser_gem, notice: 'Laser gem was successfully created.' }
        format.json { render :show, status: :created, location: @laser_gem }
      else
        format.html { render :new }
        format.json { render json: @laser_gem.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /laser_gems/1
  # PATCH/PUT /laser_gems/1.json
  def update
    respond_to do |format|
      if @laser_gem.update(laser_gem_params)
        format.html { redirect_to @laser_gem, notice: 'Laser gem was successfully updated.' }
        format.json { render :show, status: :ok, location: @laser_gem }
      else
        format.html { render :edit }
        format.json { render json: @laser_gem.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /laser_gems/1
  # DELETE /laser_gems/1.json
  def destroy
    @laser_gem.destroy
    respond_to do |format|
      format.html { redirect_to laser_gems_url, notice: 'Laser gem was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_laser_gem
      @laser_gem = LaserGem.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def laser_gem_params
      params.require(:laser_gem).permit(:name)
    end
end
