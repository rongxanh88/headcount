require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr, :repo

  def setup
    file1 = "./data/Kindergartners in full-day program.csv"
    file2 = "./data/High school graduation rates.csv"

    @dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => file1}})

    @repo = DistrictRepository.new
    repo.load_data({:enrollment => {
      :kindergarten => file1, :high_school_graduation => file2}
    })
  end

  def test_it_initializes_with_district_repository
    ha = HeadcountAnalyst.new(dr)
    assert_equal dr, ha.district_repo
  end

  def test_rate_variation
    ha = HeadcountAnalyst.new(dr)
    district1 = "ACADEMY 20"
    district2 = "Colorado"
    result = ha.kindergarten_participation_rate_variation(
      district1, :against => district2)
    assert_equal 0.766, result
  end

  def test_rate_variation_trend
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
    ha = HeadcountAnalyst.new(repo)
    name = "ACADEMY 20"
    result = ha.kindergarten_participation_against_high_school_graduation(name)
    assert_equal 0.641, result
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation
    ha = HeadcountAnalyst.new(repo)
    district = "ACADEMY 20"
    state = "STATEWIDE"

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(
      :for => district)
    refute ha.kindergarten_participation_correlates_with_high_school_graduation(
      :for => state)
  end

  def test_kindergarten_participation_correlates_with_high_school_graduation_multiple_districts
    ha = HeadcountAnalyst.new(repo)
    district_1 = "ACADEMY 20"
    district_2 = "AGATE 300"
    district_3 = "AKRON R-1"
    district_4 = "ASPEN 1"

    assert ha.kindergarten_participation_correlates_with_high_school_graduation(
      :across => [district_1, district_2, district_3, district_4])
  end

  # def test_pull_enrollment_by_name
  #   ha = HeadcountAnalyst.new(dr)
  #   name = 'ACADEMY 20'
  #   result = ha.get_enrollment(name)
  #   assert_instance_of Enrollment, result
  #   assert_equal name, result.name
  # end
end
