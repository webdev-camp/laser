class LaserGemsController < ApplicationController
  before_action :authenticate_user!,   only: [:add_comment]
  before_action :load_gem ,            only: [:show ,   :add_tag , :add_comment]
  before_action :require_owner_rights, only: [:add_tag , :add_comment]

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
  end

  def add_tag
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
    @comment = Comment.new(body: params[:comment_body], user: current_user, laser_gem: @laser_gem)
    if @comment.save
      redirect_to laser_gem_path(@laser_gem.name)
    else
      #TODO to make a modification to error message, update corresponding rspec
      flash[:notice] = "CommentError: Please insert a valid comment."
      render :show
    end
  end

  def has_owner_rights?
    return false unless current_user
    return false unless @laser_gem.is_gem_owner?(current_user)
  end

  private

  def load_gem
    @laser_gem = LaserGem.find_by_name(params[:name])
  end

  def tag_is_valid
    if params[:tag].include?(" ")
      false
    else
      true
    end
  end

  def require_owner_rights
    redirect_to laser_gem_path(@laser_gem.name) unless has_owner_rights?
  end
end
