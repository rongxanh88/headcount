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
    er = Enrollment.new(example)
    assert_instance_of Enrollment, er
  end

  def test_it_can_access_the_name_of_stored_districts
    er = Enrollment.new(example)
    assert_equal "ACADEMY 20", er.name
  end

  def test_participation_in_year
    er = Enrollment.new(example)
    assert_equal 0.391, er.kindergarten_participation_in_year(2010)
  end

  def test_unknown_year_is_nil
    er = Enrollment.new(example)
    assert_nil er.kindergarten_participation_in_year(2020)
  end

  def test_kindergarten_participation_all_year
    er = Enrollment.new(example)
    expected = {
      2010 => 0.391, 2011 => 0.353, 2012 => 0.267
    }
    result = er.kindergarten_participation_by_year
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
