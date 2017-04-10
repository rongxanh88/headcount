require './test/test_helper'
require './lib/enrollment_repository'

class EnrollmentRepositoryTest < Minitest::Test

  attr_reader :file_name

  def setup
    @file_name = "./data/Kindergartners in full-day program.csv"
  end

  def test_it_exists
    enrollment = EnrollmentRepository.new
    assert_instance_of EnrollmentRepository, enrollment
  end

  def test_load_data
    enrollment_repository = EnrollmentRepository.new
    assert enrollment_repository.load_data(file_name)
  end

  def test_find_name
    enrollment_repository = EnrollmentRepository.new
    data = enrollment_repository.load_data(file_name)
    enrollment_name = "ACADEMY 20"
    result = enrollment_repository.find_by_name(enrollment_name)
    assert_instance_of Enrollment, result
  end

end
