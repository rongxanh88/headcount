require_relative 'operations_module'
require 'pry'

class EconomicProfile
  include Operations
  attr_accessor :name, :income_data, :poverty_data,
                :lunch_data, :title_i_data

  def initialize(input)
    @name = input[:name]
    @income_data = input[:median_household_income] || Hash.new
    @poverty_data = input[:children_in_poverty] || Hash.new
    @lunch_data = input[:free_or_reduced_price_lunch] || Hash.new
    @title_i_data = input[:title_i] || Hash.new
  end

  def median_household_income_in_year(year)
    year_ranges = income_data.keys.map do |range|
      (range[0]..range[1]).to_a
    end

    incomes_from_year = year_ranges.map do |year_range|
      if year_range.include?(year)
        key = [year_range.first, year_range.last]
        income_data[key]
      end
    end

    incomes_from_year.compact!
    number_of_incomes = incomes_from_year.count
    
    raise UnknownDataError if number_of_incomes == 0

    average(incomes_from_year.reduce(:+), number_of_incomes)
  end

  def median_household_income_average
    average(income_data.values.reduce(:+), income_data.values.count)
  end
end

class UnknownDataError < Exception

end