require_relative 'test_helper'
require_relative '../lib/headcount_analyst'
require_relative '../lib/district_repository'

class HeadcountAnalystTest < Minitest::Test

  def test_it_initializes_with_district_repository
    dr = DistrictRepository.new
    ha = HeadcountAnalyst.new(dr)
    assert_equal dr, ha.district_repo
  end

  def test_it_defaults_to_nil
    ha = HeadcountAnalyst.new
    assert_nil ha.district_repo
  end
