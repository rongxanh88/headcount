require 'bigdecimal'
require 'bigdecimal/util'

class Enrollment
  attr_reader :name, :kindergarten_participation

  def initialize(input)
    @name = input[:name]
    @kindergarten_participation = input[:kindergarten_participation]
  end

  def kindergarten_participation_by_year
    kindergarten_participation.each do |k,v|
      kindergarten_participation[k] = v.to_d.truncate(3).to_f
    end
  end
end
