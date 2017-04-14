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

    return 0 if average_2 == 0  
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
        district, :against => "Colorado")

    district_graduation_variation = 
      graduation_rate_variation(district, :against => "Colorado")

    return 0 if district_graduation_variation == 0
    truncate(district_kindergarten_variation / district_graduation_variation)
  end

  def graduation_rate_variation(district1, other)
    enrollment1 = get_enrollment(district1)
    enrollment2 = get_enrollment(other[:against])
    average_1 = average(
      total_graduation_rates(enrollment1), total_num_of_graduation_values(enrollment1))
    average_2 =
      average(total_graduation_rates(enrollment2), total_num_of_graduation_values(enrollment2))
    return 0 if average_2 == 0
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

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    if !district[:across].nil?
      return correlation_across_districts(district[:across])
    end
    name = district[:for]
    result = false
    if name == "STATEWIDE"
      result = statewide_correlation
    else
      correlation = kindergarten_participation_against_high_school_graduation(name)
      result = true if correlation < 1.5 and correlation > 0.6
    end
    result
  end

  def statewide_correlation
    correlation_results = district_repo.enrollments.map do |enrollment|
      district = {:for => enrollment.name}
      kindergarten_participation_correlates_with_high_school_graduation(
        district)
    end
    number_true = correlation_results.count {|x| x == true}
    result = number_true.to_f / correlation_results.count
    
    result > 0.7 ? true : false
  end

  def correlation_across_districts(districts)
    correlation_results = districts.map do |district|
      name = {:for => district}
      kindergarten_participation_correlates_with_high_school_graduation(
        name)
    end
    number_true = correlation_results.count {|x| x == true}
    result = number_true.to_f / correlation_results.count
    
    result > 0.7 ? true : false
  end
end
