require_relative 'enrollment'
require 'CSV'
require 'pry'

class EnrollmentRepository

  attr_accessor :enrollments

  def initialize
    @enrollments = []
  end

  def load_data(files)
    kindergarten_file = files[:enrollment][:kindergarten]

    contents = CSV.open(kindergarten_file, headers: true,
                        header_converters: :symbol)

    contents.each do |row|
      row[:name] = row[:location]
      # row[:kindergarten_participation] = {row[:timeframe].to_i => row[:data].to_f}
      enrollment = Enrollment.new(row)
      enrollments << enrollment
      # p row
    end

    enrollments.uniq! {|enrollment| enrollment.name}
    contents.rewind
    participation = Hash.new
    previous_index = 0
    contents.each do |row|
      index = enrollments.find_index {|enrollment| enrollment.name == row[:location]}

      if index != previous_index
        participation = Hash.new
      end
      participation[row[:timeframe].to_i] = row[:data].to_f
      # binding.pry
      enrollments[index].kindergarten_participation = participation
      previous_index = index
    end
    p enrollments[0..10]
    # subset = enrollments.group_by {|enrollment| enrollment.name}
    # subset = []
    # enrollments.each do |enrollment|
    #
    # end
    # p subset.to_a[0].reduce {|enrollment|
    #   enrollment.kindergarten_participation
    # }
    # true
  end

end
