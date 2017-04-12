require 'bigdecimal'
require 'bigdecimal/util'
# require_relative 'enrollment'

module Operations

  def truncate(rate)
    rate.to_d.truncate(3).to_f
  end

  def average(rate, size)
    rate / size
  end

  def calculate_comparison_for_values(values1, values2)
    values1.map.each_with_index do |num, index|
      num = num / values2[index]
    end
  end

end
