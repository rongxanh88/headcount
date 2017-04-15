class District

  attr_reader :name
  attr_accessor :enrollment

  def initialize(input)
    @name = input[:name]
    @enrollment = nil
  end

end
