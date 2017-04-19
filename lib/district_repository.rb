require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'statewide_test_repository'
require_relative 'economic_profile_repository'
require_relative 'parser'
require 'csv'
require 'pry'

class DistrictRepository
  include Parser

  attr_accessor :districts
  attr_reader :enrollments, :statewide_tests

  def initialize
    @districts = []
    @enrollments = EnrollmentRepository.new
    @statewide_tests = StatewideTestRepository.new
    # @economic_profiles = EconomicProfileRepository.new
  end

  def load_data(files)
    kindergarten_file = files[:enrollment][:kindergarten]
    high_school_file = files[:enrollment][:high_school_graduation]
    @districts = Parser::Districts.get_data(kindergarten_file)
    @enrollments.load_data(files)
    add_enrollment_to_district

    if file_exists?(files[:statewide_testing])
      @statewide_tests.load_data(files)
      add_statewide_test_to_district
    end

    # if file_exists?(files[:economic_profile])
    #   @economic_profiles.load_data(files)
    #   add_economic_profile_to_district
    # end

  end

  def find_by_name(district_name)
    districts.each do |district|
      return district if district.name == district_name
    end
  end

  def find_all_matching(partial)
    sub_set = districts.keep_if { |district|
      district.name.start_with?(partial)
    }
  end


  private
  
  def add_enrollment_to_district
    districts.each_with_index do |district, index|
      district.enrollment = enrollments.enrollments[index]
    end
  end

  def add_statewide_test_to_district
    districts.each_with_index do |district, index|
      district.statewide_test = statewide_tests.statewide_tests[index]
    end
  end

  # def add_economic_profile_to_district
  #   districts.each_with_index do |district, index|
  #     district.economic_profile = economic_profiles.economic_profiles[index]
  #   end
  # end

  def file_exists?(file)
    !file.nil?
  end
end
