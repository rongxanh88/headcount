class HeadcountAnalyst

  attr_reader :district_repo

  def initialize(district_repo = nil)
    @district_repo = district_repo
  end

end
