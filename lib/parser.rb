require 'csv'

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
          if statewide_tests[index].third_grade_data.has_key?(year(row))
            statewide_tests[index].third_grade_data[year(row)][subject(row)] =
              data(row)
          else
            statewide_tests[index]
              .third_grade_data[year(row)] = {subject(row) => data(row)}
          end
        end
        statewide_tests
      end
      
      def add_eighth_grade_data(contents, statewide_tests)
        contents.each do |row|
          index = statewide_tests.find_index { |statewide_test|
            statewide_test.name == row[:location]
          }
          if statewide_tests[index].eighth_grade_data.has_key?(year(row))
            statewide_tests[index].eighth_grade_data[year(row)][subject(row)] =
              data(row)
          else
            statewide_tests[index]
              .eighth_grade_data[year(row)] = {subject(row) => data(row)}
          end
        end
        statewide_tests
      end

      def add_math_data(contents, statewide_tests)
        contents.each do |row|
          index = statewide_tests.find_index { |statewide_test|
            statewide_test.name == row[:location]
          }
          if statewide_tests[index].math_data.has_key?(race_ethnicity(row))
            statewide_tests[index].math_data[race_ethnicity(row)][year(row)] =
              {:math => data(row)}
          else
            statewide_tests[index]
              .math_data[race_ethnicity(row)] = 
                {year(row) => {:math => data(row)}}
          end
        end
        statewide_tests
      end

      def add_reading_data(contents, statewide_tests)
        contents.each do |row|
          index = statewide_tests.find_index { |statewide_test|
            statewide_test.name == row[:location]
          }
          if statewide_tests[index].reading_data.has_key?(race_ethnicity(row))
            statewide_tests[index].reading_data[race_ethnicity(row)][year(row)] =
              {:reading => data(row)}
          else
            statewide_tests[index]
              .reading_data[race_ethnicity(row)] = 
                {year(row) => {:reading => data(row)}}
          end
        end
        statewide_tests
      end

      def add_writing_data(contents, statewide_tests)
        contents.each do |row|
          index = statewide_tests.find_index { |statewide_test|
            statewide_test.name == row[:location]
          }
          if has_race_key_for_writing_data?(statewide_tests[index], row)
            statewide_tests[index].writing_data[race_ethnicity(row)][year(row)] =
              {:writing => data(row)}
          else
            statewide_tests[index]
              .writing_data[race_ethnicity(row)] = 
                {year(row) => {:writing => data(row)}}
          end
        end
        statewide_tests
      end

      def has_race_key_for_writing_data?(statewide_test, row)
        statewide_test.writing_data.has_key?(race_ethnicity(row))
      end

      def race_ethnicity(row)
        row[:race_ethnicity].downcase.to_sym
      end

      def year(row)
        row[:timeframe].to_i
      end

      def subject(row)
        row[:score].downcase.to_sym
      end

      def data(row)
        row[:data].to_f
      end

    end
  end

  class EconomicParser

    class << self

      def get_data(file)
        contents = CSV.open(
          file, headers: true, header_converters: :symbol)

        case file
        when "./data/Median household income.csv"
          @economic_profiles = create_economic_profiles_from(contents)
          contents.rewind
          return add_income_data(contents, @economic_profiles)
        when "./data/School-aged children in poverty.csv"
          return add_poverty_data(contents, @economic_profiles)
        when "./data/Students qualifying for free or reduced price lunch.csv"
          return add_lunch_data(contents, @economic_profiles)
        when "./data/Title I students.csv"
          return add_title_i_data(contents, @economic_profiles)
        end
      end

      def create_economic_profiles_from(contents)
        economic_enrollments = contents.collect do |row|
          row[:name] = row[:location]
          EconomicProfile.new(row)
        end
        economic_enrollments.uniq! {|economic_profile| economic_profile.name}
      end

      def add_income_data(contents, economic_profiles)
        contents.each do |row|
          index = economic_profiles.find_index { |economic_profile|
            economic_profile.name == row[:location]
          }

          economic_profiles[index].income_data[years(row)] =
            row[:data].to_i
        end
        economic_profiles
      end

      def add_poverty_data(contents, economic_profiles)
        contents.each do |row|
          index = economic_profiles.find_index { |economic_profile|
            economic_profile.name == row[:location]
          }
          if row[:dataformat] == "Percent"
            economic_profiles[index].poverty_data[row[:timeframe].to_i] =
              row[:data].to_f
          end
        end
        economic_profiles
      end

      def add_lunch_data(contents, economic_profiles)
        contents.each do |row|
          index = economic_profiles.find_index { |economic_profile|
            economic_profile.name == row[:location]
          }

          if row[:poverty_level] == "Eligible for Free or Reduced Lunch"

            if row[:dataformat] == "Percent"

              if economic_profiles[index].lunch_data.has_key?(row[:timeframe].to_i)
                economic_profiles[index].lunch_data[row[:timeframe].to_i][:percentage] =
                  row[:data].to_f
              else
                economic_profiles[index].lunch_data[row[:timeframe].to_i] =
                  {:percentage => row[:data].to_f}
              end

            elsif row[:dataformat] == "Number"

              if economic_profiles[index].lunch_data.has_key?(row[:timeframe].to_i)
                economic_profiles[index].lunch_data[row[:timeframe].to_i][:total] =
                  row[:data].to_f
              else
                economic_profiles[index].lunch_data[row[:timeframe].to_i] =
                  {:total => row[:data].to_f}
              end

            end
          end
        end
        economic_profiles
      end

      def add_title_i_data(contents, economic_profiles)
        contents.each do |row|
          index = economic_profiles.find_index { |economic_profile|
            economic_profile.name == row[:location]
          }
          economic_profiles[index].title_i_data[row[:timeframe].to_i] =
            row[:data].to_f
        end
        economic_profiles
      end

      def years(row)
        row[:timeframe].split("-").map {|year| year.to_i}
      end
    end
  end
end
