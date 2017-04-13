require_relative 'enrollment'
require_relative 'parser'
require 'CSV'
require 'pry'

class EnrollmentRepository
  include Parser
  attr_accessor :enrollments

  def initialize
    @enrollments = []
  end

  def load_data(files)
    kindergarten_file = files[:enrollment][:kindergarten]
    high_school_file = files[:enrollment][:high_school_graduation]
    @enrollments = Parser::Enrollments.get_data(kindergarten_file)
    if !high_school_file.nil?
      @enrollments = Parser::Enrollments.get_data(high_school_file)
    end
  end

  def find_by_name(name)
    name.upcase!
    enrollments.each do |enrollment|
      return enrollment if enrollment.name == name
    end
  end
end
