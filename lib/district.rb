class District
  attr_reader :name

  def initialize(input)
    @name = input[:name]
  end

  def name
    @name.upcase
  end

end
