require 'gosu'
require_relative 'life'

class Game < Gosu::Window
  def initialize
    super 640, 480
    self.caption = "Game of Lifes"

    @state = Set.new([
      [2,3], [3,3], [4,3]
    ])
  end

  def update
    @state = Life.tick(@state)
  end

  def draw
    Gosu.draw_rect(0, 0, 640, 480, Gosu::Color::WHITE)

    @state.each do |x, y|
      Gosu.draw_rect(x * 10, y * 10, 10, 10, Gosu::Color::BLACK)
    end
  end
end

Game.new.show
