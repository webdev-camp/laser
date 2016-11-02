class LaserGemsController < ApplicationController
  before_action :authenticate_user!, only: [:add_comment]

  # GET /laser_gems
  def index
    @laser_gems = LaserGem.paginate(page: params[:page], per_page: 20).
                           includes(:gem_spec).order(:name)
    respond_to do |format|
      format.html
      format.js
    end
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

  def add_comment
    @laser_gem = LaserGem.find_by_name(params[:name])
    @comment = Comment.new(body: params[:comment_body], user: current_user, laser_gem: @laser_gem)
    if @comment.save
      redirect_to laser_gem_path(@laser_gem.name)
    else
      flash[:notice] = "Comment error"
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
