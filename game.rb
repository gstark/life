require 'gosu'
require_relative 'life'

class Game < Gosu::Window
  FRAMERATE = 1000 / 4.0
  SCALE = 10

  def initialize
    super 640, 480
    self.caption = "Game of Life"

    @prev_state = Set.new()
    @state = Set.new()

    @is_running = true
    @space_down = false
    @elapsed = 0
  end

  def screen_to_world(x, y)
    return [(x / SCALE).floor, (y / SCALE).floor]
  end

  def world_to_screen(x, y)
    return [x * SCALE, y * SCALE]
  end

  def update
    if Gosu.button_down? Gosu::KB_SPACE
      @is_running = !@is_running if @space_down == false
      @space_down = true
    else
      @space_down = false
    end

    if Gosu.button_down? Gosu::MS_LEFT
      x,y = screen_to_world(mouse_x, mouse_y)
      @state << Cell.new(x,y)
    end

    if Gosu.milliseconds - @elapsed >= FRAMERATE
      @prev_state = @state.dup
      @state = Life.tick(@state) if @is_running
      @elapsed = Gosu.milliseconds
    end
  end

  def draw
    bg = @is_running ? Gosu::Color::WHITE : Gosu::Color::GRAY
    Gosu.draw_rect(0, 0, 640, 480, bg)

    @prev_state.each do |cell|
      Gosu.draw_rect(*world_to_screen(cell.x, cell.y), SCALE, SCALE, Gosu::Color::GRAY)
    end

    @state.each do |cell|
      Gosu.draw_rect(*world_to_screen(cell.x, cell.y), SCALE, SCALE, Gosu::Color::BLACK)
    end

    Gosu.draw_rect(*world_to_screen(*screen_to_world(mouse_x, mouse_y)), SCALE, SCALE, Gosu::Color::RED)
  end
end

Game.new.show
