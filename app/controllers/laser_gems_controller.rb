class LaserGemsController < ApplicationController
  include ApplicationHelper

  before_action :authenticate_user!,   only: [:add_comment , :add_tag]
  before_action :load_gem ,            only: [:show ,   :add_tag , :add_comment]

  impressionist actions: [ :index , :add_tag , :add_comment ]

  # GET /laser_gems
  def index
    @q = LaserGem.includes(:gem_spec , :gem_git, :taggings => :tag).ransack(params[:q])
    @laser_count = @q.result(distinct: true)
    @laser_gems = @laser_count.paginate(page: params[:page], per_page: 20)

    respond_to do |format|
      format.html
      format.js
    end
  end
  # GET /laser_gems/gem_name
  def show
    redirect_to(root_path) unless @laser_gem
    impressionist(@laser_gem) if @laser_gem
  end

  def add_tag
    if msg = tag_validation( params[:tag] )
      flash[:notice] = "Please insert a valid tag. " + msg
      render :show
    else
      @laser_gem.tag_list.add(params[:tag])
      @laser_gem.save
      redirect_to laser_gem_path(@laser_gem.name)
    end
  end

  def add_comment
    @comment = Comment.new(body: params[:comment_body], user: current_user, laser_gem: @laser_gem)
    if @comment.save
      redirect_to laser_gem_path(@laser_gem.name)
    else
      flash[:notice] = "Please insert a valid comment."
      render :show
    end
  end

  def has_owner_rights?
    return false unless current_user
    @laser_gem.is_gem_owner?(current_user)
  end
  helper_method :has_owner_rights?

  private

  def load_gem
    @laser_gem = LaserGem.find_by_name(params[:name])
  end

end
