require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  attr_reader :file_name

  def setup
    @file_name = "./data/Kindergartners in full-day program.csv"
  end

  def test_it_exists
    er = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, er
  end

  def test_load_data
    er_repository = EnrollmentRepository.new
    assert er_repository.load_data({:enrollment => {:kindergarten => file_name}})
  end

  def test_find_name
    skip
    er_repository = EnrollmentRepository.new
    data = er_repository.load_data({:enrollment => {:kindergarten => file_name}})
    er_name = "ACADEMY 20"
    result = er_repository.find_by_name(er_name)
    assert_instance_of Enrollment, result
  end

  def test_holds_district_instances
    skip
    e = EnrollmentRepository.new
    result = {}
    assert_equal result, e.districts
  end

end
