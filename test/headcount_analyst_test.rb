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

    # @dr = DistrictRepository.new
    # dr.load_data({:enrollment => {:kindergarten => file1}})
    #
    # @repo = DistrictRepository.new
    # repo.load_data({:enrollment => {
    #   :kindergarten => file1, :high_school_graduation => file2}
    # })

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
    skip
    ha = HeadcountAnalyst.new(dr)
    assert_equal dr, ha.district_repo
  end

  def test_rate_variation
    skip
    ha = HeadcountAnalyst.new(dr)
    district1 = "ACADEMY 20"
    district2 = "Colorado"
    result = ha.kindergarten_participation_rate_variation(
      district1, :against => district2)
    assert_equal 0.766, result
  end

  def test_rate_variation_trend
    skip
    ha = HeadcountAnalyst.new(dr)
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
    skip
    ha = HeadcountAnalyst.new(repo)
    name = "ACADEMY 20"
    result = ha.kindergarten_participation_against_high_school_graduation(name)
    assert_equal 0.641, result
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    skip
    ha = HeadcountAnalyst.new(repo)
    district = "ACADEMY 20"
    state = "STATEWIDE"

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(
      :for => district)
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(
      :for => state)
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_multiple_districts
    skip
    ha = HeadcountAnalyst.new(repo)
    district_1 = "ACADEMY 20"
    district_2 = "AGATE 300"
    district_3 = "AKRON R-1"
    district_4 = "ASPEN 1"

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(
      :across => [district_1, district_2, district_3, district_4])
  end

  def test_statewide_year_over_year_growth
    ha = HeadcountAnalyst.new(full_repo)

    # assert_equal 0, ha.top_statewide_test_year_over_year_growth(grade: 3)

    assert_equal 0, ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)

    # assert_raises UnknownDataError do
    #  ha.top_statewide_test_year_over_year_growth(grade: 8, subject: :math)
  #  end
  end

  # def test_pull_enrollment_by_name
  #   ha = HeadcountAnalyst.new(dr)
  #   name = 'ACADEMY 20'
  #   result = ha.get_enrollment(name)
  #   assert_instance_of Enrollment, result
  #   assert_equal name, result.name
  # end
end
