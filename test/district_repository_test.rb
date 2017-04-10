require './test/test_helper'
require './lib/district_repository'

class DistrictRepositoryTest < Minitest::Test

  def test_it_exists
    district = DistrictRepository.new
    assert_instance_of DistrictRepository, district
  end

end
