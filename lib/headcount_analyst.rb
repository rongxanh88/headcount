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
    size_1 = enrollment1.kindergarten_participation.values.count
    rate_1 = enrollment1.kindergarten_participation.values.reduce(0) {|sum,num| sum + num}
    average_1 = rate_1 / size_1
    size_2 = enrollment2.kindergarten_participation.values.count
    rate_2 = enrollment2.kindergarten_participation.values.reduce(0) {|sum,num| sum + num}
    average_2 = rate_2 / size_2
    truncate(average_1 / average_2)
  end

  def kindergarten_participation_rate_variation_trend(district1, other)
    enrollment1 = get_enrollment(district1)
    enrollment2 = get_enrollment(other[:against])

    enrollment1.kindergarten_participation = enrollment1.kindergarten_participation.sort_by {|k,v| k}.to_h
    enrollment2.kindergarten_participation = enrollment2.kindergarten_participation.sort_by {|k,v| k}.to_h
    values1 = enrollment2.kindergarten_participation.values
    values2 = enrollment1.kindergarten_participation.values
    keys = enrollment1.kindergarten_participation.keys
    numbers = values2.map.each_with_index do |num, index|
      num = num / values1[index]
    end

    trend = {}
    numbers.each_with_index do |num, index|
      trend[keys[index]] = truncate(num)
    end
    trend
  end

  def get_enrollment(district_name)
    district = district_repo.districts.select do |district|
      district.name == district_name
    end
    district[0].enrollment
  end
end
