require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test

  def test_it_exists
    dr = District.new
    assert_instance_of District, dr
  end

  def test_it_stores_the_name_of_the_district
    dr = District.new({:name => "ACADEMY 20"})
    assert_equal "ACADEMY 20", dr.name
  end

end
