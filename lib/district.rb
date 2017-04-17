class District

  attr_reader :name
  attr_accessor :enrollment, :statewide_test

  def initialize(input)
    @name = input[:name]
    @enrollment = nil
    @statewide_test = nil
  end

end
