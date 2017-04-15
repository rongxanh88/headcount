require 'csv'
require_relative 'statewide_test'

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

  class StatewideTestParser

    class << self

      def get_data(file)
        contents = CSV.open(
          file, headers: true, header_converters: :symbol)

        case file
        when "./data/3rd grade students scoring proficient or above on the CSAP_TCAP.csv"
          @statewide_tests = create_statewide_tests_from(contents)
          contents.rewind
          return add_third_grade_data(contents, @statewide_tests)
        when "./data/8th grade students scoring proficient or above on the CSAP_TCAP.csv"
          return add_eighth_grade_data(contents, @statewide_tests)
        when "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Math.csv"
          return add_math_data(contents, @statewide_tests)
        when "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Reading.csv"
          return add_reading_data(contents, @statewide_tests)
        when "./data/Average proficiency on the CSAP_TCAP by race_ethnicity_ Writing.csv"
          return add_writing_data(contents, @statewide_tests)
        end
      end

      def create_statewide_tests_from(contents)
        statewide_tests = contents.collect do |row|
          row[:name] = row[:location]
          StatewideTest.new(row)
        end
        statewide_tests.uniq! {|statewide_test| statewide_test.name}
      end

      def add_third_grade_data(contents, statewide_tests)
        contents.each do |row|
          index = statewide_tests.find_index { |statewide_test|
            statewide_test.name == row[:location]
          }
          if statewide_tests[index].third_grade_data.has_key?(row[:timeframe])
            statewide_tests[index].third_grade_data[row[:timeframe]][row[:score].to_sym] =
              row[:data].to_f
          else
            statewide_tests[index]
              .third_grade_data[row[:timeframe].to_i] = {row[:score].to_sym => row[:data].to_f}
          end
        end
        statewide_tests
      end
      
      def add_eighth_grade_data(contents, statewide_tests)
        contents.each do |row|
          index = statewide_tests.find_index { |statewide_test|
            statewide_test.name == row[:location]
          }
          if statewide_tests[index].eighth_grade_data.has_key?(row[:timeframe])
            statewide_tests[index].eighth_grade_data[row[:timeframe]][row[:score].to_sym] =
              row[:data].to_f
          else
            statewide_tests[index]
              .eighth_grade_data[row[:timeframe].to_i] = {row[:score].to_sym => row[:data].to_f}
          end
        end
        statewide_tests
      end

      def add_math_data(contents, statewide_tests)
        # contents.each do |row|
        #   index = statewide_tests.find_index { |statewide_test|
        #     statewide_test.name == row[:location]
        #   }
        #     statewide_tests[index]
        #       .math_data[row[:race_ethnicity]] = {row[:timeframe] = {math: row[:data]}}
        # end
        statewide_tests
      end

      def add_reading_data(contents, statewide_tests)
        # contents.each do |row|
        #   index = statewide_tests.find_index { |statewide_test|
        #     statewide_test.name == row[:location]
        #   }
        #     statewide_tests[index]
        #       .reading_data[row[:race_ethnicity] = {row[:timeframe] = {reading: row[:data]}}
        # end
        statewide_tests
      end

      def add_writing_data(contents, statewide_tests)
        # contents.each do |row|
        #   index = statewide_tests.find_index { |statewide_test|
        #     statewide_test.name == row[:location]
        #   }
        #     statewide_tests[index]
        #       .writing_data[row[:race_ethnicity] = {row[:timeframe] = {writing: row[:data]}}
        # end
        statewide_tests
      end
    end
  end
end
