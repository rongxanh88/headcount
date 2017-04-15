class StatewideTestRepository
  attr_reader :statewide_tests
  def initialize
    @statewide_tests = []
  end

  def load_data(files)
    third_grade_file = files[:statewide_testing][:third_grade]
    eigth_grade_file = files[:statewide_testing][:eighth_grade]
    math_file = files[:statewide_testing][:math]
    reading_file = files[:statewide_testing][:reading]
    writing_file = files[:statewide_testing][:writing]

    @statewide_tests = Parser::StatewideTest.get_data(third_grade_file)
  end
end