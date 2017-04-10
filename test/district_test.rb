require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_it_exists
    district = District.new
    assert_instance_of District, district
  end

end
