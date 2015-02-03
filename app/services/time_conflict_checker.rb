class TimeConflictChecker
  attr_accessor :range_1, :range_2
  def initialize(range_1, range_2)
    @range_1 = range_1
    @range_2 = range_2
  end

  def conflicts?
    return true if range_2.overlaps?(range_1)
    false
  end
end

