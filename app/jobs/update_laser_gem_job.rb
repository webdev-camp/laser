require "gem_loader"
require "git_loader"

class UpdateLaserGemJob < ApplicationJob

  def perform(gem_name)
    gem_data_fetch(gem_name)
  end

  def gem_data_fetch(gem_name)
    laser_gem = GemLoader.new.create_or_update_spec(gem_name)
    GitLoader.new.update_or_create_git(laser_gem)
    laser_gem.touch
    Ranking.new(laser_gem).total_rank_calc
    Ranking.new(laser_gem).download_rank_string_calc
    Ranking.new(laser_gem).download_rank_percent_calc
  end
end
