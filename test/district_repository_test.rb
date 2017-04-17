require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  attr_reader :dr

  def setup
    file_name = "./data/Kindergartners in full-day program.csv"
    @dr = DistrictRepository.new
    dr.load_data({:enrollment => {:kindergarten => file_name}})
  end

  def test_it_exists
    assert_instance_of DistrictRepository, dr
  end

  def test_find_name
    dr_name = "ACADEMY 20"
    result = dr.find_by_name(dr_name)
    assert_instance_of District, result
  end

  def test_find_all_matching
    partial_name = "AR"
    result = dr.find_all_matching(partial_name)
    assert_equal 3, result.size
  end

  def test_holds_district_instances
    d = DistrictRepository.new
    assert_equal [], d.districts
  end

  def test_district_access_enrollment
    dr_name = "ACADEMY 20"
    district = dr.find_by_name(dr_name)
    assert_instance_of Enrollment, district.enrollment
  end

  def test_enrollment_rate_for_year
    dr_name = "ACADEMY 20"
    district = dr.find_by_name(dr_name)
    result = district.enrollment.kindergarten_participation_in_year(2010)
    assert_equal 0.436, result
  end

  def test_district_relationship_to_statewide_tests
    repo = DistrictRepository.new
    repo.load_data({
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

    district = repo.find_by_name("ACADEMY 20")
    assert_instance_of StatewideTest, district.statewide_test
  end

end
