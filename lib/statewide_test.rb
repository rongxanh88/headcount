require_relative 'operations_module'

class StatewideTest
  include Operations
  attr_accessor :name, :third_grade_data, :eighth_grade_data,
                :math_data, :reading_data, :writing_data

  def initialize(input)
    @name = input[:name]
    @third_grade_data = input[:third_grade] || Hash.new
    @eighth_grade_data = input[:eighth_grade] || Hash.new
    @math_data = input[:math] || Hash.new
    @reading_data = input[:reading] || Hash.new
    @writing_data = input[:writing] || Hash.new
  end

  def proficient_by_grade(grade)
    if grade == 3
      return third_grade_data
    elsif grade == 8
      return eighth_grade_data
    else
      raise UnknownDataError.new
    end
  end

  def proficient_by_race_or_ethnicity(race)
    combo = {}
    combo[race] = self.math_data[race]

    raise UnknownRaceError.new if combo[race].nil?

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
    check_for_data_and_grade_errors(subject, grade, year)

    answer = 0
    if grade == 3
      answer = self.third_grade_data[year][subject]
    else
      answer = self.eighth_grade_data[year][subject]
    end

    answer = "N/A" if answer == 0
    return answer
  end

  def proficient_for_subject_by_race_in_year(subject, race, year)
    check_for_data_and_race_errors(subject, race, year)

    if subject == :math
      return truncate(self.math_data[race][year][subject])
    elsif subject == :reading
      return truncate(self.reading_data[race][year][subject])
    elsif subject == :writing
      return truncate(self.writing_data[race][year][subject])
    end
  end

  private

  def check_for_data_and_grade_errors(subject, grade, year)
    if grade != 3 and grade != 8
      raise UnknownDataError.new
    elsif subject != :math and subject != :reading and subject != :writing
      raise UnknownDataError.new
    elsif !self.third_grade_data.has_key?(year)
      raise UnknownDataError.new
    end
  end

  def check_for_data_and_race_errors(subject, race, year)
    races = [
      :"all students", :asian, :black, :"hawaiian/pacific islander",
      :hispanic, :"native american", :"two or more", :white
    ]
    subjects = [:math, :reading, :writing]
    if !races.include?(race)
      raise UnknownDataError.new
    elsif !subjects.include?(subject)
      raise UnknownDataError.new
    elsif !self.math_data[race].include?(year)
      raise UnknownDataError.new
    end
  end
end

class UnknownDataError < Exception
end

class UnknownRaceError < Exception
end