require_relative 'operations_module'

class Enrollment
  include Operations
  attr_reader :name
  attr_accessor :kindergarten_participation,
                :high_school_graduation_rates

  def initialize(input)
    @name = input[:name]
    @kindergarten_participation = input[:kindergarten_participation]
    if kindergarten_participation.nil?
      @kindergarten_participation = Hash.new
    end
    @high_school_graduation_rates = input[:high_school_graduation_rates]
    if high_school_graduation_rates.nil?
      @high_school_graduation_rates = Hash.new
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

  def graduation_rate_by_year
    high_school_graduation_rates.each do |k,v|
        high_school_graduation_rates[k] = truncate(v)
    end
  end

  def graduation_rate_in_year(year)
    if high_school_graduation_rates.has_key? (year)
      truncate(high_school_graduation_rates[year])
    else
      nil
    end
  end
end
