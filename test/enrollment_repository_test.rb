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
    er_repo = EnrollmentRepository.new
    assert er_repo.load_data({:enrollment => {:kindergarten => file_name}})
  end

  def test_find_name
    er_repo = EnrollmentRepository.new
    er_repo.load_data({:enrollment => {:kindergarten => file_name}})
    er_name = "ACADEMY 20"
    result = er_repo.find_by_name(er_name)
    assert_instance_of Enrollment, result
  end

  def test_holds_district_instances
    e = EnrollmentRepository.new
    assert_equal [], e.enrollments
  end

  def test_get_enrollment_participation
    er_repo = EnrollmentRepository.new
    er_repo.load_data({:enrollment => {:kindergarten => file_name}})
    er_name = "ACADEMY 20"
    enrollment = er_repo.find_by_name(er_name)
    participation_by_year = {
      2007=>0.391, 2006=>0.353, 2005=>0.267, 2004=>0.302, 2008=>0.384,
      2009=>0.39, 2010=>0.436, 2011=>0.489, 2012=>0.478, 2013=>0.487,
      2014=>0.49
    }
    assert_equal participation_by_year, enrollment.kindergarten_participation_by_year
  end

  def test_get_enrollment_participation_in_single_year
    er_repo = EnrollmentRepository.new
    er_repo.load_data({:enrollment => {:kindergarten => file_name}})
    er_name = "JEFFERSON COUNTY R-1"
    enrollment = er_repo.find_by_name(er_name)
    result = enrollment.kindergarten_participation_in_year(2012)
    assert_equal 0.728, result
  end

end
