require './lib/economic_profile'
require './test/test_helper'

class EconomicProfileTest < Minitest::Test

  def test_it_exists
    assert_instance_of EconomicProfile, EconomicProfile.new
  end
end