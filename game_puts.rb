# require 'gosu'
require_relative 'life'

class GamePuts # < Gosu::Window
  FRAMERATE = 1000 / 4.0
  SCALE = 10

  def initialize
    # super 640, 480
    # self.caption = "Game of Lifes"

    @prev_state = Set.new()
    # @state = Set.new()
    # @state = Set.new([ [2,3], [3,3], [4,3] ])
    @state = Set.new([ [1,1], [3,1], [3,2], [5,3], [5,4], [5,5], [7,4], [7,5], [7,6], [8,5] ])

    @is_running = true
    @space_down = false
    @elapsed = 0
    @tick = 0
  end

  # def screen_to_world(x, y)
  #   return [(x / SCALE).floor, (y / SCALE).floor]
  # end

  # def world_to_screen(x, y)
  #   return [x * SCALE, y * SCALE]
  # end

  def show(ticks = 0)
    draw
    (ticks || 0).times do |tick|
      update
      draw
    end
  end

  def update
    @tick += 1
    # if Gosu.button_down? Gosu::KB_SPACE
    #   @is_running = !@is_running if @space_down == false
    #   @space_down = true
    # else
    #   @space_down = false
    # end

    # if Gosu.button_down? Gosu::MS_LEFT
    #   @state << screen_to_world(mouse_x, mouse_y)
    # end

    # if Gosu.milliseconds - @elapsed >= FRAMERATE
      @prev_state = @state.dup
      @state = Life.tick(@state) if @is_running
  end

  def grid_range(state)
    x_vals = state.collect{|cell| cell[0]}
    y_vals = state.collect{|cell| cell[1]}
    x_min = (x_vals.min || 0) - 1
    y_min = (y_vals.min || 0) - 1
    x_max = (x_vals.max || 0) + 1
    y_max = (y_vals.max || 0) + 1
    {x_range: (x_min..x_max), y_range: (y_min..y_max)}
  end

  def grid(state, grid_below = {})
    range = grid_range(state)
    g = {}
    g[:range] = range
    g[:cells] = {}
    rx = range[:x_range]
    ry = range[:y_range]
    ry.each do |y|
      rx.each do |x|
        coord = [x,y]
        g[:cells][coord] ||= 0
        g[:cells][coord] += grid_below[:cells][coord] * 0.5 if grid_below.keys.include?(:cells) && grid_below[:cells].keys.include?(coord)
        g[:cells][coord] += 1.0 if state.include?(coord)
      end
    end
    g
  end

  def float_to_char10(val)
    char_range = " .:-=+*#%@"
    float_to_char(char_range, val)
  end

  def float_to_char3(val)
    char_range = " *X"
    float_to_char(char_range, val)
  end

  def float_to_char71(val)
    char_range = " .'\`^\",:;Il!i><~+_-?][}{1)(|/tfjrxnuvczXYUJCLQ0OZmwqpdbkhao*#MW&8%B@$"
    float_to_char(char_range, val)
  end

  def float_to_char(char_range, val)
    clen = char_range.length
    # val = 0.0 if val < 0.0
    # val = 1.0 if val > 1.0
    v_scaled = (val*clen).floor
    v_scaled = 0 if v_scaled < 0
    v_scaled = clen - 1 if v_scaled > clen - 1
    char_range[v_scaled]
  end

  def grid_to_txt(grid)
    txt = ''
    rx = grid[:range][:x_range]
    ry = grid[:range][:y_range]
    cells = grid[:cells]
    ry.to_a.reverse.each do |y|
      rx.each do |x|
        coord = [x,y]
        v = (grid.keys.include?(:cells) && grid[:cells].keys.include?(coord)) ? grid[:cells][coord] : 0
        # i = (v*10).floor
        c = float_to_char3(v)
        if v <= 0
          c = case
            when x == 0 && y == 0
              '+'
            when x == 0
              (y % 10).to_s # '|'
            when y == 0
              (x % 10).to_s # '-'
            else
              ' '
          end
        end
        
        # # puts "v: #{v}, i: #{i}, c: #{c}"
        # puts "v: #{v}, c: #{c}"
        txt << c
      end
      txt << "\n"
    end
    txt
  end

  def draw
    prev_grid = grid(@prev_state, grid_below = {})
    cur_grid = grid(@state, prev_grid)

    puts
    puts 'v' * 80
    puts "tick: #{@tick}"
    puts
    puts grid_to_txt(cur_grid)
    puts '^' * 80
    puts
  end

end

GamePuts.new.show(ARGV[0].to_i)
