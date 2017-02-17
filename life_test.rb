require 'minitest/autorun'
require_relative 'life'

class LifeTest < MiniTest::Test
  BLOCK = Set.new([
    [1,1],[1,2],
    [2,1],[2,2]
  ])

  BLINKER_H = Set.new([
    [2,3], [3,3], [4,3]
  ])

  BLINKER_V = Set.new([
    [3,2],
    [3,3],
    [3,4]
  ])

  def test_block
    game = Life.new(BLOCK)
    assert_equal BLOCK, game.tick
  end

  def test_blinker
    game = Life.new(BLINKER_H)
    assert_equal BLINKER_V, game.tick
    assert_equal BLINKER_H, game.tick
  end
end
