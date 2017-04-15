require 'bigdecimal'
require 'bigdecimal/util'

module Operations

  def truncate(rate)
    return 0 if rate.nan?
    rate.to_d.truncate(3).to_f
  end

  def average(rate, size)
    return 0 if size == 0
    rate / size
  end

  def calculate_comparison_for_values(values1, values2)
    values1.map.each_with_index do |num, index|
      num = num / values2[index]
    end
  end

end
