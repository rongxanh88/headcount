module Parser

  class Districts
    class << self
      def get_data(file_name)
        contents = CSV.open(
          file_name, headers: true, header_converters: :symbol)

        districts = get_districts_from(contents)
      end

      def get_districts_from(contents)
        districts = contents.collect do |row|
          row[:name] = row[:location]
          District.new(row)
        end
        districts.uniq! {|district| district.name}
      end
    end
  end

  class Enrollments
    class << self
      def get_data(file_name)
        contents = CSV.open(file_name, headers: true,
                          header_converters: :symbol)

        enrollments = get_enrollments_from(contents)
        contents.rewind
        return add_participation_to_enrollments(contents, enrollments)
      end

      def get_enrollments_from(contents)
        enrollments = contents.collect do |row|
          row[:name] = row[:location]
          Enrollment.new(row)
        end
        enrollments.uniq! {|enrollment| enrollment.name}
      end

      def add_participation_to_enrollments(contents, enrollments)
        contents.each do |row|
          index = enrollments.find_index { |enrollment|
            enrollment.name == row[:location]
          }
            enrollments[index]
              .kindergarten_participation[year(row)] = rate(row)
        end
        enrollments
      end

      def year(row)
        row[:timeframe].to_i
      end

      def rate(row)
        row[:data].to_f
      end

    end
  end
end