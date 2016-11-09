module ApplicationHelper
  def downloads_by_name
    bar_chart downloads_by_name_charts_path, height: '100px', library: {
      title: {text: 'Gem', x: -20},
      yAxis: {
         allowDecimals: false,
         title: {
             text: 'Ages count'
         }
      },
      xAxis: {
         title: {
             text: 'Downloads'
         }
      }
    }
  end
end
