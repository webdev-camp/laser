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

  def search_tag_url tag_name
    q = {}
    q["taggings_tag_name_eq"] = tag_name
    if params[:q].present?
      name = params[:q]["name_or_gem_spec_info_cont"]
      q["name_or_gem_spec_info_cont"]= name if(name)
    end
    laser_gems_path(q: q)
  end
end
