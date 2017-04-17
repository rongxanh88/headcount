require_relative 'operations_module'
require 'pry'

class StatewideTest
  include Operations
  attr_accessor :name, :third_grade_data, :eighth_grade_data,
                :math_data, :reading_data, :writing_data

  def initialize(input)
    @name = input[:name]

    @third_grade_data = input[:third_grade]
    if third_grade_data.nil?
      @third_grade_data = Hash.new
    end

    @eighth_grade_data = input[:eighth_grade]
    if eighth_grade_data.nil?
      @eighth_grade_data = Hash.new
    end

    @math_data = input[:math]
    if math_data.nil?
      @math_data = Hash.new
    end

    @reading_data = input[:reading]
    if reading_data.nil?
      @reading_data = Hash.new
    end

    @writing_data = input[:writing]
    if writing_data.nil?
      @writing_data = Hash.new
    end
  end

  def proficient_by_grade(grade)
    if grade == 3
      return third_grade_data
    elsif grade == 8
      return eighth_grade_data
    else
      raise Exception.new("UnknownDataError")
    end
  end

  def proficient_by_race_or_ethnicity(race)
    combo = {}
    combo[race] = self.math_data[race]

    if combo[race].nil?
      raise Exception.new("UnknownRaceError")
    end
    
    combo[race].each do |k,v|
      v = v.to_a
      v << self.reading_data[race][k].to_a.flatten
      v << self.writing_data[race][k].to_a.flatten

      v.map do |score|
        score[1] = truncate(score[1])
      end

      combo[race][k] = v.to_h
    end
    combo[race]
  end

  def proficient_for_subject_by_grade_in_year(subject, grade, year)
    if grade != 3 and grade != 8
      raise Exception.new("UnknownDataError")
    elsif subject != :math and subject != :reading and subject != :writing
      raise Exception.new("UnknownDataError")
    elsif !self.third_grade_data.has_key?(year)
      raise Exception.new("UnknownDataError")
    end

    
  end
end