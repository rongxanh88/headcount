class District
  attr_reader :name

  def initialize(input)
    @name = input[:name]
  end

  def name
    result = @name.upcase
  end

end
