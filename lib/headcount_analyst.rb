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
    if !enrollment.high_school_graduation_rates.nil?
      enrollment.high_school_graduation_rates =
        enrollment.high_school_graduation_rates.sort_by {|k,v| k}.to_h
    end
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

  def kindergarten_participation_against_high_school_graduation(district)
    # enrollment = get_enrollment(district)
    # state_enrollment = get_enrollment("COLORADO")

    # state_kindergarten_values = get_enrollment_values(enrollment)
    # state_enrollment_values = get_enrollment_values(state_enrollment)
    district_kindergarten_variation = 
      kindergarten_participation_rate_variation(
        district, :against => "COLORADO")

    district_graduation_variation = 
      graduation_rate_variation(district, :against => "COLORADO")

    result = district_kindergarten_variation / district_graduation_variation
  end

  def graduation_rate_variation(district1, other)
    enrollment1 = get_enrollment(district1)
    enrollment2 = get_enrollment(other[:against])
    average_1 = average(
      total_graduation_rates(enrollment1), total_num_of_graduation_values(enrollment1))
    average_2 =
      average(total_graduation_rates(enrollment2), total_num_of_graduation_values(enrollment2))
    truncate(average_1 / average_2)
  end

  def get_graduation_values(enrollment)
    enrollment.high_school_graduation_rates.values
  end

  def total_graduation_rates(enrollment)
    enrollment.high_school_graduation_rates.values.reduce(0) {|sum,num| sum + num}
  end

  def total_num_of_graduation_values(enrollment)
    enrollment.high_school_graduation_rates.values.count
  end
end
