require 'pry'
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
    attr_reader :enrollments
    class << self
      def get_data(file_name)
        contents = CSV.open(file_name, headers: true,
        header_converters: :symbol)
        if file_name == "./data/Kindergartners in full-day program.csv"
          @enrollments = create_enrollments_from(contents)
          contents.rewind
          return add_participation_to_enrollments(contents, @enrollments)
        elsif file_name == "./data/High school graduation rates.csv"
          return add_high_school_graduation_rates(contents, @enrollments)
        end
      end

      def create_enrollments_from(contents)
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

      def add_high_school_graduation_rates(contents, enrollments)
        contents.each do |row|
          index = enrollments.find_index { |enrollment|
            enrollment.name == row[:location]
          }
            enrollments[index]
              .high_school_graduation_rates[year(row)] = rate(row)
        end
        enrollments
      end

    end
  end
end
