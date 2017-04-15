require 'pry'

class StatewideTest
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

  #methods below
end