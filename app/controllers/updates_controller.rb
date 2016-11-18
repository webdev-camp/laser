class UpdatesController < ApplicationController
  before_action :authenticate_user!

  def show
  end

  def update
    gem_name = params[:gem_name]
    # add notices for invalid gem and for updating a gem
    loader = GemLoader.new
    if LaserGem.find_by(name: gem_name)
      redirect_to laser_gem_path(gem_name), notice: "You have sucessfully requested an update for this gem, check back in a while to see if it has loaded."
    elsif loader.get_spec_from_api(gem_name) == nil
      redirect_to updates_show_path, notice: "This does not appear to be a valid gem. Please make sure this gem has been uploaded to rubygems.org"
    else
      redirect_to updates_show_path, notice: "You have sucessfully added a gem, check back in a while to see if it has loaded."
      gem_data_fetch(gem_name)
    end
  end

  def gem_data_fetch(gem_name)
    gemloader = GemLoader.new
    gemloader.create_or_update_spec(gem_name)
    # add gitloader methods
    # add ranking
  end
end
