class AnnouncementsController < ApplicationController
  before_action :set_announcement, only: [:show, :edit, :update]
  before_action :authenticate_user!, only: [:new, :edit, :update]
  before_action :require_admin_rights, only: [:new, :edit, :update]

  # GET /announcements
  def index
    @announcements = Announcement.all
    if Announcement.first == nil
      @empty = true
    else
      @empty = false
    end
  end

  # GET /announcements/1
  def show
  end

  # GET /announcements/new
  def new
    @announcement = Announcement.new
  end

  # GET /announcements/1/edit
  def edit
  end

  # POST /announcements
  def create
    @announcement = Announcement.new(announcement_params)
    @announcement.user = current_user

    if @announcement.save
      redirect_to @announcement, notice: 'Announcement was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /announcements/1
  def update
    if @announcement.update(announcement_params)
      redirect_to @announcement, notice: 'Announcement was successfully updated.'
    else
      render :edit
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_announcement
      @announcement = Announcement.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def announcement_params
      params.require(:announcement).permit(:title, :body)
    end
end
