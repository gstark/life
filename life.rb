require 'set'

class Cell < Struct.new(:x,:y)
  def offset(dx,dy)
    Cell.new(x + dx, y+dy)
  end
end

class Life
  DELTA = (-1..1).to_a.product((-1..1).to_a) - [[0,0]]
  LIVE_NEIGHBOR_COUNT = Set.new([2,3])
  DEAD_NEIGHBOR_COUNT = Set.new([3])

  def self.tick(state)
    state.
      # Work on a copy of the state
      dup.
      # Merge in all the neighbors
      merge(state.flat_map { |cell| DELTA.map { |dx, dy| cell.offset(dx,dy) } }).
      # Select only the cells that live to the next genreation
      select { |cell| (state.include?(cell) ? LIVE_NEIGHBOR_COUNT : DEAD_NEIGHBOR_COUNT).include?(DELTA.count { |dx, dy| state.include?(cell.offset(dx,dy)) }) }.
      # Set#select returns an array, so convert back to a set
      to_set
  end
end
