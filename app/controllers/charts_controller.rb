class ChartsController < ApplicationController
  # def gemspecs_by_total_downloads
  #   result = GemSpec.group(:total_downloads).count
  #   render json: [{name: 'Count', data: result}]
  # end
  def downloads_by_name
    result = {}
    GemSpec.all.map do |gg|
      result[gg.name] = gg.total_downloads
    end
    render json: [{name: 'Total Downloads', data: result}]
  end
end
