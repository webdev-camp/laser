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

  def laser_gems_cloud
    LaserGem.all.includes(:gem_spec).order(:name).limit(10)
  end
end
