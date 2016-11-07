module RankingsHelper
  def downloads_by_name
    column_chart downloads_by_name_charts_path, library: {
      title: {text: 'Total Downloads', x: -20},
      yAxis: {
        crosshair: true,
        title: {
          text: 'Total Downloads'
        }
      },
      xAxis: {
        crosshair: true,
        title: {
          text: 'Gem'
        }
      }
    }
  end
end
