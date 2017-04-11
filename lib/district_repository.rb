require_relative 'district'
require 'csv'
require 'pry'

class DistrictRepository
  attr_accessor :districts

  def initialize
    @districts = []
  end

  def load_data(files)
    kindergarten_file = files[:enrollment][:kindergarten]

    contents = CSV.open(kindergarten_file, headers: true,
                        header_converters: :symbol)

    contents.each do |row|
      row[:name] = row[:location]
      district = District.new(row)
      districts << district
    end
    districts.uniq! {|district| district.name}
    true
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
