require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test
  attr_reader :enrollment

  def setup
    kindergarten_data = {
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}
      }
    enrollment = Enrollment.new(kindergarten_data)
  end

  def test_it_exists
    assert_instance_of Enrollment, enrollment
  end

  def test_it_can_access_the_name_of_stored_districts
    assert_equal "ACADEMY 20", enrollment.name
  end

  def test_participation_in_year
    assert_equal 0.391, enrollment.kindergarten_participation_in_year(2010)
  end

  def test_unknown_year_is_nil
    assert_nil enrollment.kindergarten_participation_in_year(2020)
  end

  def test_kindergarten_participation_all_year
    expected = {
      2010 => 0.391, 2011 => 0.353, 2012 => 0.267
    }
    result = enrollment.kindergarten_participation_by_year
    assert_equal expected, result
  end

  def test_graduation_rate_by_year
    data = {
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
      :high_school_graduation_rates => {
        2010 => 0.895, 2011 => 0.895, 2012 => 0.889,
        2013 => 0.913, 2014 => 0.898}
      }
    er = Enrollment.new(data)
    expected = {
        2010 => 0.895, 2011 => 0.895, 2012 => 0.889,
        2013 => 0.913, 2014 => 0.898
      }
    assert_equal expected, er.graduation_rate_by_year
  end

  def test_graduation_rate_in_year
    data = {
      :name => "ACADEMY 20",
      :kindergarten_participation => {
        2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677},
      :high_school_graduation_rates => {
        2010 => 0.895, 2011 => 0.895, 2012 => 0.889,
        2013 => 0.913, 2014 => 0.898}
      }
    er = Enrollment.new(data)
    assert_equal 0.895, er.graduation_rate_in_year(2010)
  end

end
