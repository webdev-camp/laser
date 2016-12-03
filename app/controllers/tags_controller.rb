class TagsController < ApplicationController
  before_action :set_tag, only: [:show, :edit, :update, :destroy]
  before_action :require_admin_rights

  impressionist

  def index
    @tags = ActsAsTaggableOn::Tag.all
  end

  def show
  end

  def new
    @tag = ActsAsTaggableOn::Tag.new
  end

  def edit
  end

  def create
    @tag = ActsAsTaggableOn::Tag.new(tag_params)

    respond_to do |format|
      if @tag.save
        format.html { redirect_to tag_path(@tag), notice: 'Tag was successfully created.' }
        format.json { render :show, status: :created, location: @tag }
      else
        format.html { render :new }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @tag.update(tag_params)
        format.html { redirect_to tag_path(@tag), notice: 'Tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @tag }
      else
        format.html { render :edit }
        format.json { render json: @tag.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @tag.destroy
    respond_to do |format|
      format.html { redirect_to tags_url, notice: 'Tag was successfully destroyed.' }
      format.json { head :no_content }
    end
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
