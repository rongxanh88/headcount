require './test/vtest_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_it_exists
    er = Enrollment.new
    assert_instance_of Enrollment, er
  end

  def test_it_can_access_the_name_of_stored_districts
    er = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => 0.3915, 2011 => 0.35356, 2012 => 0.2677}})
    assert_equal "ACADEMY 20", er.name
  end

  def test_participation_by_year
    er = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => '.391', 2011 => '.353', 2012 => '.267'}})
    assert_equal ({2010=>0.391, 2011=>0.353, 2012=>0.267}), er.kindergarten_participation_by_year
  end

  def test__participation_in_year
    er = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2010 => '.391', 2011 => '.353', 2012 => '.267'}})
    assert_equal 0.391, er.kindergarten_participation_in_year(2010)
  end

  def test_unknown_year_is_nil
    er = Enrollment.new({:name => "ACADEMY 20", :kindergarten_participation => {2020 => nil}})
    assert_equal ({2020 => nil}), er.kindergarten_participation_in_year(2020)
  end

end
