require_relative 'operations_module'
require 'pry'

class EconomicProfile
  include Operations
  attr_accessor :name, :income_data, :poverty_data,
                :lunch_data, :title_i_data

  def initialize(input)
    @name = input[:name]
    @income_data = input[:third_grade] || Hash.new
    @poverty_data = input[:eighth_grade] || Hash.new
    @lunch_data = input[:math] || Hash.new
    @title_i_data = input[:reading] || Hash.new
  end
end