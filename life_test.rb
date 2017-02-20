require 'minitest/autorun'
require_relative 'life'

class LifeTest < MiniTest::Test
  BLOCK = Set.new([
    Cell.new(1,1), Cell.new(1,2),
    Cell.new(2,1), Cell.new(2,2),
  ])

  BLINKER_H = Set.new([
    Cell.new(2,3), Cell.new(3,3), Cell.new(4,3)
  ])

  BLINKER_V = Set.new([
    Cell.new(3,2),
    Cell.new(3,3),
    Cell.new(3,4)
  ])

  def test_block
    assert_equal BLOCK, Life.tick(BLOCK)
  end

  def test_blinker
    game = Life.new
    assert_equal BLINKER_V, Life.tick(BLINKER_H)
    assert_equal BLINKER_H, Life.tick(BLINKER_V)
  end
end
