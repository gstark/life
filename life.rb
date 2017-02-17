require 'set'

class Life
  def initialize(initial_state)
    @state = initial_state
  end

  def for_neighbors(cell)
    (-1..1).each do |delta_x|
      (-1..1).each do |delta_y|
        next if [0,0] == [delta_x, delta_y]
        x = cell[0] + delta_x
        y = cell[1] + delta_y
        yield [x,y]
      end
    end
  end

  def tick
    all_cells = Set.new
    @state.each do |cell|
      for_neighbors(cell) do |x,y|
        all_cells << [x, y]
      end
    end

    all_cells.merge(@state)

    next_state = Set.new

    all_cells.each do |cell|
      alive_count = 0
      for_neighbors(cell) do |x,y|
        alive_count += 1 if @state.include?([x,y])
      end

      if @state.include?(cell)
        next_state << cell if alive_count == 2 || alive_count == 3
      else
        next_state << cell if alive_count == 3
      end
    end
    @state = next_state
  end
end
