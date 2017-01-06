class TagsController < ApplicationController
  include ApplicationHelper

  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_rights

  impressionist

  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
  end

  def edit
  end

  def new
    redirect_to tags_path , notice: "Create tags on gem page"
  end

  def update
    @tag.name = tag_params[:name]
    if msg = tag_validation( @tag.name )
      flash.now.notice = 'Invalid tag.' + msg
      render :edit
    else
      @tag.save
      redirect_to tag_path(@tag), notice: 'Tag was successfully updated.'
    end
  end

  def destroy
    if @tag.taggings_count > 0
      notice = "Only unused tags can be destroyed"
    else
      notice = 'Tag was successfully destroyed.'
      @tag.destroy
    end
    redirect_to tags_url, notice: notice
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_tag
      @tag = ActsAsTaggableOn::Tag.find_by(id: params[:id])
      @tag = ActsAsTaggableOn::Tag.find_by(name: params[:id]) unless @tag
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def tag_params
      params.require(:acts_as_taggable_on_tag).permit(:name)
    end
end
