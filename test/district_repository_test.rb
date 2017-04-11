require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  attr_reader :file_name

  def setup
    @file_name = "./data/Kindergartners in full-day program.csv"
  end

  def test_it_exists
    dr = DistrictRepository.new
    assert_instance_of DistrictRepository, dr
  end

  def test_load_data
    dr = DistrictRepository.new
    assert dr.load_data({:enrollment => {kindergarten => file_name}})
  end

  def test_find_name
    dr = DistrictRepository.new
    data = dr.load_data(file_name)
    dr_name = "ACADEMY 20"
    result = dr.find_by_name(dr_name)
    assert_instance_of District, result
  end

  def test_find_all_matching
    dr = DistrictRepository.new
    data = dr.load_data(file_name)
    partial_name = "AR"
    expected = ["ARICKAREE R-2", "ARRIBA-FLAGLER C-20"]
    result = dr.find_all_matching(partial_name)
    assert_equal expected, result
  end

  def test_holds_district_instances
    d = DistrictRepository.new
    result = {}
    assert_equal result, d.drs
  end
end
