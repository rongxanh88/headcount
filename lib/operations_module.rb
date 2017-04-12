require 'bigdecimal'
require 'bigdecimal/util'

module Operations

  def truncate(rate)
    rate.to_d.truncate(3).to_f
  end

end
