require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test
  attr_reader :dr

  def setup
    file_name = "./data/Kindergartners in full-day program.csv"
    @dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => file_name}})
  end

  def test_it_initializes_with_district_repository
    ha = HeadcountAnalyst.new(dr)
    assert_equal dr, ha.district_repo
  end

  def test_rate_variation
    ha = HeadcountAnalyst.new(dr)
    district1 = "ACADEMY 20"
    district2 = "COLORADO"
    result = ha.kindergarten_participation_rate_variation(
      district1, :against => district2)
    assert_equal 0.766, result
  end

  def test_rate_variation_trend
    ha = HeadcountAnalyst.new(dr)
    district1 = "ACADEMY 20"
    district2 = "COLORADO"
    expected = {
      2004 => 1.257, 2005 => 0.96, 2006 => 1.05, 2007 => 0.992,
      2008 => 0.717, 2009 => 0.652, 2010 => 0.681, 2011 => 0.727,
      2012 => 0.688, 2013 => 0.694, 2014 => 0.661
    }
    result = ha.kindergarten_participation_rate_variation_trend(
      district1, :against => district2)
    assert_equal expected, result
  end

  def test_pull_enrollment_by_name
    ha = HeadcountAnalyst.new(dr)
    name = 'ACADEMY 20'
    result = ha.get_enrollment(name)
    assert_instance_of Enrollment, result
    assert_equal name, result.name
  end

end
