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
    
    raise UnknownDataError.new if number_of_incomes == 0

    average(incomes_from_year.reduce(:+), number_of_incomes)
  end

  def median_household_income_average
    average(income_data.values.reduce(:+), income_data.values.count)
  end

  def children_in_poverty_in_year(year)
    raise UnknownDataError.new if poverty_data[year].nil?
    poverty_data[year]
  end

  def free_or_reduced_price_lunch_percentage_in_year(year)
    raise UnknownDataError.new if lunch_data[year][:percentage].nil?
    truncate(lunch_data[year][:percentage])
  end

  def free_or_reduced_price_lunch_number_in_year(year)
    raise UnknownDataError.new if lunch_data[year][:total].nil?
    lunch_data[year][:total].to_i
  end

  def title_i_in_year(year)
    raise UnknownDataError.new if title_i_data[year].nil?
    truncate(title_i_data[year])
  end
end

class UnknownDataError < Exception

end