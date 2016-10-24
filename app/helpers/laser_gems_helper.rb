module LaserGemsHelper
  def k_numbers(number)
    if number > 1000
       "#{number / 1000}k"
     else
       number.to_s
    end
  end
end
