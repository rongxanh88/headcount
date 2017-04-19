require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr, :repo, :full_repo

  def setup
    file1 = "./data/Kindergartners in full-day program.csv"
    file2 = "./data/High school graduation rates.csv"
    file3 = "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
    file4 = "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
    file5 = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv"
    file6 = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv"
    file7 = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"

    @full_repo = DistrictRepository.new
    full_repo.load_data({
      :enrollment => {
        :kindergarten => "./data/Kindergartners in full-day program.csv",
        :high_school_graduation => "./data/High school graduation rates.csv",
      },
      :statewide_testing => {
        :third_grade => "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv",
        :eighth_grade => "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv",
        :math => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv",
        :reading => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv",
        :writing => "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
      }
    })
  end

  def test_it_initializes_with_district_repository
    ha = HeadcountAnalyst.new(full_repo)
    assert_equal full_repo, ha.district_repo
  end

  def test_rate_variation
    ha = HeadcountAnalyst.new(full_repo)
    district1 = "ACADEMY 20"
    district2 = "Colorado"
    result = ha.kindergarten_participation_rate_variation(
      district1, :against => district2)
    assert_equal 0.766, result
  end

  def test_rate_variation_trend
    ha = HeadcountAnalyst.new(full_repo)
    district1 = "ACADEMY 20"
    district2 = "Colorado"
    expected = {
      2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992,
      2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727,
      2012 => 0.688, 2013 => 0.694, 2014 => 0.661
    }
    result = ha.kindergarten_participation_rate_variation_trend(
      district1, :against => district2)
    assert_equal expected, result
  end

  def test_high_school_graduation_correlates_kindergarten_participation
    ha = HeadcountAnalyst.new(full_repo)
    name = "ACADEMY 20"
    result = ha.kindergarten_participation_against_high_school_graduation(name)
    assert_equal 0.641, result
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    ha = HeadcountAnalyst.new(full_repo)
    district = "ACADEMY 20"
    state = "STATEWIDE"

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(
      :for => district)
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(
      :for => state)
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_multiple_districts
    ha = HeadcountAnalyst.new(full_repo)
    district_1 = "ACADEMY 20"
    district_2 = "AGATE 300"
    district_3 = "AKRON R-1"
    district_4 = "ASPEN 1"

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(
      :across => [district_1, district_2, district_3, district_4])
  end

  def test_statewide_year_over_year_growth_grade_3
    ha = HeadcountAnalyst.new(full_repo)
    district = "SANGRE DE CRISTO RE-22J"
    result = ha.top_statewide_test_year_over_year_growth(grade: 3)

    assert_equal district, result.first
    assert_equal 0.071, result.last
  end

  def test_statewide_year_over_year_growth_grade_8
    ha = HeadcountAnalyst.new(full_repo)

    district_2 = "OURAY R-1"
    result = ha.top_statewide_test_year_over_year_growth(grade: 8)

    assert_equal district_2, result.first
    assert_equal 0.11, result.last
  end

  def test_single_subject_year_over_year
    ha = HeadcountAnalyst.new(full_repo)
    district_3 = "WILEY RE-13 JT"
    result = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :math)

    assert_equal district_3, result.first
    assert_equal 0.3, result.last

    district_4 = "COTOPAXI RE-3"
    result = ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :reading)

    assert_equal district_4, result.first
    assert_equal 0.131, result.last

    district_5 = "BETHUNE R-5"
    result = ha.top_statewide_test_year_over_year_growth(grade: 3, subject: :writing)

    assert_equal district_5, result.first
    assert_equal 0.148, result.last
  end

  def test_raises_insufficient_info
    ha = HeadcountAnalyst.new(full_repo)

    assert_raises InsufficientInformationError do
      ha.top_statewide_test_year_over_year_growth(subject: :math)
    end
  end

  def test_year_over_year_growth_with_weighting
    ha = HeadcountAnalyst.new(full_repo)
    district = "OURAY R-1"
    result = ha.top_statewide_test_year_over_year_growth(
      grade: 8, :weighting => {:math => 0.5, :reading => 0.5, :writing => 0.0})
      
    assert_equal district, result.first
    assert_equal 0.153, result.last
  end

end
