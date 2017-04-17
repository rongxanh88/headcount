require './lib/economic_profile_repository'
require './test/test_helper'

class EconomicProfileRepositoryTest < Minitest::Test

  def setup

  end
  
  def test_it_exists
    assert_instance_of EconomicProfileRepository, EconomicProfileRepository.new
  end

  def test_load_files
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
end