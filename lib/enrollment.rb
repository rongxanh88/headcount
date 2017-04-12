require 'bigdecimal'
require 'bigdecimal/util'

class Enrollment
  attr_reader :name
  attr_accessor :kindergarten_participation

  def initialize(input)
    @name = input[:name]
    @kindergarten_participation = input[:kindergarten_participation]
    if kindergarten_participation.nil?
      @kindergarten_participation = Hash.new
    end
  end

  def kindergarten_participation_by_year
    kindergarten_participation.each do |k,v|
        kindergarten_participation[k] = truncate(v)
    end
  end

  def kindergarten_participation_in_year(year)
    if kindergarten_participation.has_key? (year)
      truncate(kindergarten_participation[year])
    else
      nil
    end
  end

  def truncate(rate)
    rate.to_d.truncate(3).to_f
  end
end
