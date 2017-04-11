require './test/test_helper'
require './lib/district'

class DistrictTest < Minitest::Test
  attr_reader :district_name

  def setup
    @district_name = {:name => "ACADEMY 20"}
  end

  def test_it_exists
    dr = District.new(district_name)
    assert_instance_of District, dr
  end
  
  def test_has_name
    district = District.new(district_name)
    assert_equal "ACADEMY 20", district.name
  end

end
