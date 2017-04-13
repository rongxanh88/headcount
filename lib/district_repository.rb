require_relative 'district'
require_relative 'enrollment_repository'
require_relative 'parser'
require 'csv'
require 'pry'

class DistrictRepository
  include Parser

  attr_accessor :districts
  attr_reader :enrollments

  def initialize
    @districts = []
    @enrollments = EnrollmentRepository.new
  end

  def load_data(files)
    kindergarten_file = files[:enrollment][:kindergarten]
    high_school_file = files[:enrollment][:high_school_graduation]
    @districts = Parser::Districts.get_data(kindergarten_file)
    @enrollments = Parser::Enrollments.get_data(kindergarten_file)

    if !high_school_file.nil?
      @enrollments = Parser::Enrollments.get_data(high_school_file)
    end

    add_enrollment_to_district
  end

  def find_by_name(district_name)
    district_name.upcase!
    districts.each do |district|
      return district if district.name == district_name
    end
  end

  def find_all_matching(partial)
    sub_set = districts.keep_if { |district|
      district.name.start_with?(partial)
    }
  end

  def add_enrollment_to_district
    districts.each_with_index do |district, index|
      district.enrollment = enrollments[index]
    end
  end
end
