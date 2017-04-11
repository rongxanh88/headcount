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
    @enrollments = Parser::Enrollments.get_data(kindergarten_file)
    # sanitize_enrollments
  end

  def find_by_name(name)
    name.upcase!
    enrollments.each do |enrollment|
      return enrollment if enrollment.name == name
    end
  end

  # def sanitize_enrollments
  #   enrollments.each do |enrollment|
  #     enrollment_rates = enrollment.kindergarten_participation
  #     enrollment_rates.each do |year, rate|
  #       enrollment_rates[year] = 0 if rate == "N/A"
  #     end
  #   end
  # end
end
