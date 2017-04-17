require_relative 'economic_profile'
require_relative 'parser'
require 'pry'

class EconomicProfileRepository
  include Parser
  attr_reader :economic_profiles
  def initialize
    @economic_profiles = []
  end

  def load_data(files)
    median_income_file = files[:economic_profile][:median_household_income]
    children_in_poverty_file = files[:economic_profile][:children_in_poverty]
    lunch_file = files[:economic_profile][:free_or_reduced_price_lunch]
    title_i_file = files[:economic_profile][:title_i]
    @economic_profiles = Parser::EconomicParser.get_data(median_income_file)
    @economic_profiles = Parser::EconomicParser.get_data(children_in_poverty_file)
    @economic_profiles = Parser::EconomicParser.get_data(lunch_file)
    @economic_profiles = Parser::EconomicParser.get_data(title_i_file)
  end

  def find_by_name(district_name)
    economic_profiles.each do |economic_profile|
      return economic_profile if economic_profile.name == district_name
    end
  end
end