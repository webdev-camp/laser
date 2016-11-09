class LaserGemsController < ApplicationController
  before_action :authenticate_user!, only: [:add_comment]

  # GET /laser_gems
  def index
    @q = LaserGem.includes(:gem_spec).ransack(params[:q])
    @laser_gems = @q.result(distinct: true).
      paginate(page: params[:page], per_page: 20).includes(:gem_spec).order(:name)

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
      #TODO to make a modification to error message, update corresponding rspec
      flash[:notice] = "CommentError: Please insert a valid comment."
      render :show
    end
  end

  def commit_activity_chart
    @laser_gem = LaserGem.find_by_name(params[:name])
    result = {}
    commit_act = @laser_gem.gem_git.commit_dates_year
    commit_act.each.collect do |ca|
      result[ca[1].to_s] = ca[0]
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
