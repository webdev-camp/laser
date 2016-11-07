# class RankingsController < ApplicationController
#   def downloads_by_name
#     result = {}
#     GemSpec.all.map do |gg|
#       result[gg.name] = gg.total_downloads
#     end
#     render json: [{name: 'Total Downloads', data: result}]
#   end
# end
