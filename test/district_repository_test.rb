require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  attr_reader :file_name

  def setup
    @file_name = "./data/Kindergartners in full-day program.csv"
  end

  def test_it_exists
    district = DistrictRepository.new
    assert_instance_of DistrictRepository, district
  end

  def test_load_data
    district = DistrictRepository.new
    assert district.load_data(file_name)
  end

  def test_find_name
    district = DistrictRepository.new
    data = district.load_data(file_name)
    district_name = "ACADEMY 20"
    result = district.find_by_name(district_name)
    assert_instance_of District, result
  end

  def test_find_all_matching
    district = DistrictRepository.new
    data = district.load_data(file_name)
    partial_name = "AR"
    expected = ["ARICKAREE R-2", "ARRIBA-FLAGLER C-20"]
    result = district.find_all_matching(partial_name)
    assert_equal expected, result
  end
end
