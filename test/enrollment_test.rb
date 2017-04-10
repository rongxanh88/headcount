require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test
  attr_reader :example

  def setup
    @example = {
      :name => "ACADEMY 20", 
      :kindergarten_participation => {
        2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
      }
  end

  def test_it_exists
    enrollment = Enrollment.new(example)
    assert_instance_of Enrollment, enrollment
  end

  def test_kindergarten_participation_by_year
    enrollment = Enrollment.new(example)
    expected = {
      2010 => 0.391, 2011 => 0.353, 2012 => 0.267
    }
    result = enrollment.kindergarten_participation_by_year
    assert_equal expected, result
  end

end
