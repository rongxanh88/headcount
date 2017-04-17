require './test/test_helper'
require './lib/statewide_test_repository'

class StatewideTestRepositoryTest < Minitest::Test
  attr_reader :str
  def setup
    third_grade_file = "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
    eighth_grade_file = "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
    math_file = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv"
    reading_file = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv"
    writing_file = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    @str = StatewideTestRepository.new
    str.load_data({
      :statewide_testing => {
      :third_grade => third_grade_file,
      :eighth_grade => eighth_grade_file,
      :math => math_file,
      :reading => reading_file,
      :writing => writing_file
      }
    })
  end

  def test_load_data
    skip
    # third_grade_file = "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
    # eighth_grade_file = "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
    # math_file = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv"
    # reading_file = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv"
    # writing_file = "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
    # @str = StatewideTestRepository.new
    # str.load_data({
    #   :statewide_testing => {
    #   :third_grade => third_grade_file,
    #   :eighth_grade => eighth_grade_file,
    #   :math => math_file,
    #   :reading => reading_file,
    #   :writing => writing_file
    #   }
    # })
  end
  
  def test_find_by_name
    district = str.find_by_name("ACADEMY 20")

    assert_instance_of StatewideTest, district
  end

  def test_get_test_scores_by_grade
    district = str.find_by_name("ACADEMY 20")
    expected = {
      2008=>{:Math=>0.857, :Reading=>0.866, :Writing=>0.671},
      2009=>{:Math=>0.824, :Reading=>0.862, :Writing=>0.706},
      2010=>{:Math=>0.849, :Reading=>0.864, :Writing=>0.662},
      2011=>{:Math=>0.819, :Reading=>0.867, :Writing=>0.678},
      2012=>{:Reading=>0.87, :Math=>0.83, :Writing=>0.65517},
      2013=>{:Math=>0.8554, :Reading=>0.85923, :Writing=>0.6687},
      2014=>{:Math=>0.8345, :Reading=>0.83101, :Writing=>0.63942}
    }
    assert_equal expected, district.proficient_by_grade(3)
    assert_instance_of Hash, district.proficient_by_grade(8)
    # assert_equal 0, district.proficient_by_grade(10)
  end

  def test_get_scores_by_race
    district = str.find_by_name("ACADEMY 20")
    expected = {
      2011=>{:math=>0.816, :reading=>0.897, :writing=>0.826},
      2012=>{:math=>0.818, :reading=>0.893, :writing=>0.808},
      2013=>{:math=>0.805, :reading=>0.901, :writing=>0.81},
      2014=>{:math=>0.8, :reading=>0.855, :writing=>0.789}
    }
    result = district.proficient_by_race_or_ethnicity(:Asian)

    assert_equal expected, result
  end

  def test_proficiency_by_subject_grade_and_year
    subject, grade, year = :math, 3, 2008
    result = str.proficient_for_subject_by_grade_in_year(subject, grade, year)

    assert_equal 0.857, result
  end

  # def test_proficiency_by_subject_race_and_year
  #   skip
  #   subject, race, year = :math, :asian, 2012
  #   result = str.proficient_for_subject_by_race_in_year(subject, race, year)

  #   assert_equal 0.818, result
  # end

  # def test_proficiency_with_invalid_parameter
  #   skip
  #   subject, race, year = :science, :brown, 2018
  #   bad_result = str.proficient_for_subject_by_race_in_year(subject, race, year)
  #   another_result = str.proficient_for_subject_by_grade_in_year(subject, grade, year)

  #   assert_equal UnknownDataError, bad_result
  #   assert_equal UnknownDataError, another_result
  # end

#Old Tests

  # def test_get_scores_for_unknown_race
  #   district = str.find_by_name("ACADEMY 20")
  #   bad_result = district.proficient_by_race_or_ethnicity(:brown)

  #   assert_equal UnknownRaceError, bad_result
  # end
end