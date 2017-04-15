require_relative 'parser'
require 'pry'

class StatewideTestRepository
  include Parser
  attr_reader :statewide_tests
  def initialize
    @statewide_tests = []
  end

  def load_data(files)
    third_grade_file = files[:statewide_testing][:third_grade]
    eighth_grade_file = files[:statewide_testing][:eighth_grade]
    math_file = files[:statewide_testing][:math]
    reading_file = files[:statewide_testing][:reading]
    writing_file = files[:statewide_testing][:writing]
    @statewide_tests = Parser::StatewideTestParser.get_data(third_grade_file)
    @statewide_tests = Parser::StatewideTestParser.get_data(eighth_grade_file)
    @statewide_tests = Parser::StatewideTestParser.get_data(math_file)
    @statewide_tests = Parser::StatewideTestParser.get_data(reading_file)
    @statewide_tests = Parser::StatewideTestParser.get_data(writing_file)
  end

  def find_by_name(district_name)
    statewide_tests.each do |statewide_test|
      return statewide_test if statewide_test.name == district_name
    end
  end
end