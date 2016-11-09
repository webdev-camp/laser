module LaserGemsHelper
  def k_numbers(number)
    if number > 1000
       "#{number / 1000}k"
     else
       number.to_s
    end
  end

  def tags_cloud
    ActsAsTaggableOn::Tag.most_used(5)
  end

  #TODO replace from alphabetical order to rank order
  def laser_gems_cloud
    LaserGem.all.includes(:gem_spec).order(:name).limit(10)
  end

  def search_tag_url tag_name
    q = {}
    q["taggings_tag_name_eq"] = tag_name
    if params[:q].present?
      name = params[:q]["name_or_gem_spec_info_cont"]
      q["name_or_gem_spec_info_cont"]= name if(name)
    end
    laser_gems_path(q: q)
  end

  def chart_options_long
    { height: "200px",
      ytitle: "Commits per Week",
      label: "Commits per Week",
      library: { plotOptions: { series: { lineColor: '#3b5f7c' } },
        xAxis: { tickInterval: 8153600000, title: { text: "Date" } }
      }
    }
  end
  def chart_options_short
    { height: "150px",
      ytitle: "Commits",
      label: "Commits",
      library: { plotOptions: { series: { lineColor: '#3b5f7c' } },
        xAxis: { title: { enabled: false } , labels: {enabled: false}}
      }
    }
  end
  def activity_chart(laser_gem , type = :long)
    return "" unless laser_gem and laser_gem.gem_git
    options = send "chart_options_#{type}".to_sym
    weeks =  52.times.collect{|i| (Time.now - i.weeks).to_date }.reverse
    commit_act = laser_gem.gem_git.commit_dates_year
    line_chart(weeks.zip(commit_act) , options )
  end

end
