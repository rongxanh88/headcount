require './test/test_helper'
require './lib/enrollment'

class EnrollmentTest < Minitest::Test

  def test_it_exists
    enrollment = Enrollment.new
    assert_instance_of Enrollment, enrollment
  end

end
