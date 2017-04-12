require_relative 'operations_module'
require 'pry'

class HeadcountAnalyst
  include Operations
  attr_reader :district_repo

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district1, other)
    enrollment1 = get_enrollment(district1)
    enrollment2 = get_enrollment(other[:against])
    average_1 = average(
      total_rates(enrollment1), total_num_of_values(enrollment1))
    average_2 =
      average(total_rates(enrollment2), total_num_of_values(enrollment2))
    truncate(average_1 / average_2)
  end

  def kindergarten_participation_rate_variation_trend(district1, other)
    enrollment1 = get_enrollment(district1)
    enrollment2 = get_enrollment(other[:against])

    sort_enrollment_keys(enrollment1)
    sort_enrollment_keys(enrollment2)
    keys = enrollment1.kindergarten_participation.keys
    numbers = calculate_comparison_for_values(
      get_enrollment_values(enrollment1),
      get_enrollment_values(enrollment2))

    output_trend(keys, numbers)
  end

  def get_enrollment(district_name)
    district = district_repo.districts.select do |district|
      district.name == district_name
    end
    district[0].enrollment
  end

  def sort_enrollment_keys(enrollment)
    enrollment.kindergarten_participation =
      enrollment.kindergarten_participation.sort_by {|k,v| k}.to_h
  end

  def get_enrollment_values(enrollment)
    enrollment.kindergarten_participation.values
  end

  def output_trend(keys, values)
    trend = {}
    values.each_with_index do |num, index|
      trend[keys[index]] = truncate(num)
    end
    trend
  end

  def total_rates(enrollment)
    enrollment.kindergarten_participation.values.reduce(0) {|sum,num| sum + num}
  end

  def total_num_of_values(enrollment)
    enrollment.kindergarten_participation.values.count
  end
end
