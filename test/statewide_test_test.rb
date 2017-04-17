require './test/test_helper'
require './lib/statewide_test'

class StatewideTestTest < Minitest::Test

  def test_it_exists
    swt = StatewideTest.new({:name => "Colorado"})
    assert_instance_of StatewideTest, swt
  end

end