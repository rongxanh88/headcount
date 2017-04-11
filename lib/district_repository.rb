require_relative 'district'
require_relative 'parser'
require 'csv'
require 'pry'

class DistrictRepository
  include Parser
  attr_accessor :districts

  def initialize
    @districts = []
  end

  def load_data(files)
    kindergarten_file = files[:enrollment][:kindergarten]
    @districts = Parser::Districts.get_data(kindergarten_file)
  end

  def find_by_name(district_name)
    district_name.upcase!
    districts.each do |district|
      return district if district.name == district_name
    end
  end

  def find_all_matching(partial)
    sub_set = districts.keep_if { |district|
      district.name.start_with?(partial)
    }
  end
end
