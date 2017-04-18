require_relative 'operations_module'
require 'pry'

class HeadcountAnalyst
  include Operations
  attr_reader :district_repo

  STATE = "Colorado"

  def initialize(district_repo)
    @district_repo = district_repo
  end

  def kindergarten_participation_rate_variation(district1, other)
    enrollment1 = get_enrollment(district1)
    enrollment2 = get_enrollment(other[:against])
    average_1 = average(
      add_kindergarten_values(enrollment1),
      count_of_kindergaten_values(enrollment1))
    average_2 = average(
      add_kindergarten_values(enrollment2),
      count_of_kindergaten_values(enrollment2))

    truncate(average_1 / average_2)
  end

  def kindergarten_participation_rate_variation_trend(district1, other)
    enrollment1 = get_enrollment(district1)
    enrollment2 = get_enrollment(other[:against])

    sort_enrollment_keys(enrollment1)
    sort_enrollment_keys(enrollment2)
    keys = enrollment1.kindergarten_participation.keys
    numbers = calculate_comparison_for_values(
      kindergarten_participation_values(enrollment1),
      kindergarten_participation_values(enrollment2))

    output_trend(keys, numbers)
  end

  def kindergarten_participation_against_high_school_graduation(district)
    district_kindergarten_variation =
      kindergarten_participation_rate_variation(
        district, :against => STATE)

    district_graduation_variation =
      graduation_rate_variation(district, :against => STATE)

    truncate(district_kindergarten_variation / district_graduation_variation)
  end

  def kindergarten_participation_correlates_with_high_school_graduation(district)
    if !district[:across].nil?
      enrollments = district[:across].map do |district_name|
        get_enrollment(district_name)
      end
      return correlation_across_districts(enrollments)
    end
    name = district[:for]
    result = false
    if name == "STATEWIDE"
      result = correlation_across_districts(district_repo.enrollments)
    else
      correlation = kindergarten_participation_against_high_school_graduation(name)
      result = true if correlation < 1.5 and correlation > 0.6
    end
    result
  end

  def top_statewide_test_year_over_year_growth(grade)
    if grade[:grade] == 3
      all_districts_year_over_year = {}

      district_repo.statewide_tests.statewide_tests.each do |statewide_test|
        scores = Array.new

        statewide_test.third_grade_data.each do |year, subjects|
          score = average(
            (statewide_test.third_grade_data[year][:math]) +
            (statewide_test.third_grade_data[year][:reading]) +
            (statewide_test.third_grade_data[year][:writing]), 3)
          scores << score
        end

        biggest_num = (scores.last - scores.first) / (scores.count - 1)

        all_districts_year_over_year[statewide_test.name] = biggest_num

      end
      answer = all_districts_year_over_year.sort_by {|k, v| v}.reverse.to_a
      answer.shift(2)
      return answer.first
    elsif grade[:grade] == 8
      all_districts_year_over_year = {}

      district_repo.statewide_tests.statewide_tests.each do |statewide_test|
        scores = Array.new

        statewide_test.eighth_grade_data.each do |year, subjects|
          score = average(
            (statewide_test.eighth_grade_data[year][:math]) +
            (statewide_test.eighth_grade_data[year][:reading]) +
            (statewide_test.eighth_grade_data[year][:writing]), 3)
          scores << score
        end

        biggest_num = (scores.last - scores.first) / (scores.count - 1)

        all_districts_year_over_year[statewide_test.name] = biggest_num

      end
      answer = all_districts_year_over_year.sort_by {|k, v| v}.reverse.to_a
      # answer.shift(2)
      binding.pry
      return answer.first
    else
      raise UnknownDataError.new
    end
  end

  private

  def graduation_rate_variation(district1, other)
    enrollment1 = get_enrollment(district1)
    enrollment2 = get_enrollment(other[:against])
    average_1 = average(
      add_graduation_rates(enrollment1), count_graduation_values(enrollment1))
    average_2 =
      average(add_graduation_rates(enrollment2), count_graduation_values(enrollment2))
    return 0 if average_2 == 0
    truncate(average_1 / average_2)
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
    if graduation_rates_exists?(enrollment)
      enrollment.high_school_graduation_rates =
        enrollment.high_school_graduation_rates.sort_by {|k,v| k}.to_h
    end
  end

  def graduation_rates_exists?(enrollment)
    !enrollment.high_school_graduation_rates.nil?
  end

  def kindergarten_participation_values(enrollment)
    enrollment.kindergarten_participation.values
  end

  def output_trend(keys, values)
    trend = {}
    values.each_with_index do |num, index|
      trend[keys[index]] = truncate(num)
    end
    trend
  end

  def count_of_kindergaten_values(enrollment)
    enrollment.kindergarten_participation.values.count
  end

  def add_graduation_rates(enrollment)
    enrollment.high_school_graduation_rates.values.reduce(0) {|sum,num| sum + num}
  end

  def count_graduation_values(enrollment)
    enrollment.high_school_graduation_rates.values.count
  end

  def add_kindergarten_values(enrollment)
    enrollment.kindergarten_participation.values.reduce(0) {|sum,num| sum + num}
  end

  def correlation_across_districts(enrollments)
    correlation_results = enrollments.map do |enrollment|
      district_name = {:for => enrollment.name}
      kindergarten_participation_correlates_with_high_school_graduation(
        district_name)
    end

    is_correlation?(correlation_results)
  end

  def is_correlation?(correlation_results)
    number_true = correlation_results.count {|x| x == true}
    result = number_true.to_f / correlation_results.count

    result > 0.7 ? true : false
  end

end

class UnknownDataError < Exception

end
