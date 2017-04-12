module Parser

  class Districts
    def self.get_data(file_name)
      districts = []
      contents = CSV.open(file_name, headers: true,
                        header_converters: :symbol)

      contents.each do |row|
        row[:name] = row[:location]
        district = District.new(row)
        districts << district
      end
      districts.uniq! {|district| district.name}
    end
  end

  class Enrollments
    def self.get_data(file_name)
      enrollments = []
      contents = CSV.open(file_name, headers: true,
                        header_converters: :symbol)

      contents.each do |row|
        row[:name] = row[:location]
        enrollment = Enrollment.new(row)
        enrollments << enrollment
      end

      enrollments.uniq! {|enrollment| enrollment.name}
      contents.rewind
      contents.each do |row|
        index = enrollments.find_index {|enrollment|
          enrollment.name == row[:location]
        }
          enrollments[index]
          .kindergarten_participation[row[:timeframe].to_i] = row[:data].to_f
      end
      enrollments
    end
  end
end