require './lib/economic_profile_repository'
require './test/test_helper'

class EconomicProfileRepositoryTest < Minitest::Test
  attr_reader :repo

  def setup
    @repo = EconomicProfileRepository.new
    repo.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
  end
  
  def test_it_exists
    assert_instance_of EconomicProfileRepository, EconomicProfileRepository.new
  end

  def test_load_files
    skip
    repo = EconomicProfileRepository.new
    repo.load_data({
      :economic_profile => {
        :median_household_income => "./data/Median household income.csv",
        :children_in_poverty => "./data/School-aged children in poverty.csv",
        :free_or_reduced_price_lunch => "./data/Students qualifying for free or reduced price lunch.csv",
        :title_i => "./data/Title I students.csv"
      }
    })
  end

  def test_median_household_income_for_year
    district = repo.find_by_name("ACADEMY 20")

    assert_equal 85060, district.median_household_income_in_year(2005)
    assert_equal 87635, district.median_household_income_in_year(2009)
  end

  def test_median_household_income_average
    district = repo.find_by_name("ACADEMY 20")

    assert_equal 87635, district.median_household_income_average
  end

  def test_children_in_poverty_in_year
    district = repo.find_by_name("ACADEMY 20")

    assert_equal 0.064, district.children_in_poverty_in_year(2012)
  end

  def test_free_or_reduced_price_lunch_percentage_in_year
    district = repo.find_by_name("ACADEMY 20")
    result = district.free_or_reduced_price_lunch_percentage_in_year(2014)

    assert_equal 0.127, result
  end

  def test_free_or_reduced_price_lunch_number_in_year
    district = repo.find_by_name("ACADEMY 20")
    result = district.free_or_reduced_price_lunch_number_in_year(2014)

    assert_equal 3132, result
  end

  def test_title_i_in_year
    district = repo.find_by_name("ACADEMY 20")
    result = district.title_i_in_year(2009)

    assert_equal 0.014, result
  end

  def test_bad_data
    district = repo.find_by_name("ACADEMY 20")

    assert_raises UnknownDataError do
      district.median_household_income_in_year(1900)
      district.children_in_poverty_in_year(1900)
      district.free_or_reduced_price_lunch_percentage_in_year(1900)
      district.free_or_reduced_price_lunch_number_in_year(1900)
      district.title_i_in_year(2010)
    end
  end
end